Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXLWG6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXLWG6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 01:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbXLWG6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 01:58:05 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:30572 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751522AbXLWG6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 01:58:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Z8tmer2oxZvQMjRx76ATMragGyb5y9bc4JAnJ0RRoSKg8z0Lq4loslV/0K8EhhE/ItiE2RfOOy3AhilEyIuGonFgaMTIC5dXnEJ8AlmWz1HOds/gdRHQYu3KaFZ742WG7+S5ngxklXdQTZGXPKolRkwpYZNhzxvPc7/xiyJZXe0=  ;
X-YMail-OSG: Z_UnO58VM1mXbs1Mbtz.I0Z.7SYJqKV4nFFFuCrX57UDTmw0ckQlDomKUZJZm146b7HOkaLRy5m5khHMKmjcWH.9CwrwqQeoQiHAL312V8douLlCoKzJaVxsWgGb
Date: Sun, 23 Dec 2007 07:55:25 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/63] ide-cd: redux
Message-ID: <20071223065525.GA5003@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200712200148.49690.bzolnier@gmail.com> <20071220121157.GA7162@gollum.tnic> <200712212057.49502.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712212057.49502.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 08:57:49PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 20 December 2007, Borislav Petkov wrote:
> > On Thu, Dec 20, 2007 at 01:48:49AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > Hi Bart,
> > Hi all,
> > 
> > > PS ide-cd Maintainer position is still open...
> > i'd like to take that position if nobody objects. I've done some work around the
> > kernel here and there and i think its time for me to get serious.
> 
> Great!
> 
> Please send me a patch for MAINTAINERS file updating ide-cd entry.

Sure, there it is:

---

Reopen ide-cd for maintainership.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
diff --git a/MAINTAINERS b/MAINTAINERS
index 3c7db62..fb59941 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1870,8 +1870,10 @@ T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
 
 IDE/ATAPI CDROM DRIVER
+P:	Borislav Petkov
+M:	bbpetkov@yahoo.de
 L:	linux-ide@vger.kernel.org
-S:	Unmaintained
+S:	Maintained
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-- 
Regards/Gruﬂ,
    Boris.
