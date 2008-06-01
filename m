Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYFAFJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYFAFJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 01:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYFAFJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 01:09:23 -0400
Received: from mx1.riseup.net ([204.13.164.18]:35321 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYFAFJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 01:09:22 -0400
Date: Sun, 1 Jun 2008 07:09:12 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Malley <mail@chrismalley.co.uk>
Subject: Re: [patch 1/2] MTD: use list_for_each_entry() in add_mtd_device()
Message-ID: <20080601050912.GC8734@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	dwmw2@infradead.org, linux-mtd@lists.infradead.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Chris Malley <mail@chrismalley.co.uk>
References: <20080531132808.644758754@kaehlcke.net> <20080531132808.984625508@kaehlcke.net> <20080531133511.GA8734@traven> <20080531194154.GA7055@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080531194154.GA7055@logfs.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, May 31, 2008 at 09:41:55PM +0200 Jörn Engel ha dit:

> On Sat, 31 May 2008 15:35:11 +0200, Matthias Kaehlcke wrote:
> > 
> > MTD: use list_for_each_entry() instead of list_for_each() in add_mtd_device()
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> 
> Chris Malley (added to Cc:) sent a patch converting all of drivers/mtd/
> in a similar fashion.  It should be on its way in, if dwmw2 hasn't
> missed it.

fine :)
 
> You might also want to check your mailer.  This patch looks like bouquet
> of flowers that got stuck in an elevator door. ;)

thanks for the pointer. normally my mutt/emacs config doesn't cause
this type of problems, i suppose i screwed it up myself somehow ...

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

    The book of nature is written in the language of mathematics
                         (Galileo Galilei)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
