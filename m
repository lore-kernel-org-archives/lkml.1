Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYBIMIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYBIMIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbYBIMGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:06:10 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:36751 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757621AbYBIMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:06:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=IHfba26uYgcsLnnLsau/0XNbUD772ITRsrNokh74LCPnGs/nMyKarGqREtFBr7ClYO3Jg9li/JsgdO7WCeCbId5dHih9iCNYPWjHjxoUjVCjLC+tTeUNAcvEIkrzq73/j+XgDzbl9KvOrm8HxkA2kt6GL4+Ok42QVFjcqhfL98M=;
X-YMail-OSG: ZC9tY54VM1kFeq6zEVDNqkF1RLI2V_a.ME9EKs3lF9ccEmMCIFvPGvzkkKUC4Yb6BnhOb7TABpNz5oc8lY2rYdwF53rrdQITDxivLAnJ7Jx2b_s3PlQUQyX2dEOBdD56txHJ6ABf5vnKJHEFUUrMDg--
Date: Sat, 9 Feb 2008 12:06:06 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.og
In-Reply-To: <20080209064810.GB29926@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <842653.5028.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Greg KH <greg@kroah.com> wrote:

> On Fri, Feb 08, 2008 at 11:31:24PM +0000, Chris Rankin wrote:
> > I've just tried booting the 2.6.24.1 kernel, except without
> > nmi_watchdog being enabled. It looks like there are IRQs still not
> > being enabled.
> 
> Does 2.6.24 work?  Is this a 2.6.24.1 regression?

Nope, 2.6.24 doesn't work either. So there's an important fix needed somewhere for 2.6.24.2 ...
;-)

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

