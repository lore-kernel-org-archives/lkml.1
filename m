Return-Path: <linux-kernel-owner+w=401wt.eu-S965270AbXBLSij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270AbXBLSij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965276AbXBLSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:38:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:34231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965270AbXBLSii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:38:38 -0500
Date: Mon, 12 Feb 2007 10:37:13 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tilman Schmidt <tilman@imap.cc>, Jiri Kosina <jikos@jikos.cz>,
       hjlipp@web.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Usb-Devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: gigaset build broken on current linux-2.6.git
Message-ID: <20070212183713.GA32607@kroah.com>
References: <45CBA41D.3000406@garzik.org> <Pine.LNX.4.64.0702082344100.25686@twin.jikos.cz> <45CC3109.1010502@imap.cc> <45CF630F.1040706@imap.cc> <20070211184727.GB15182@kroah.com> <20070212061659.GB10409@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212061659.GB10409@havoc.gtf.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 01:16:59AM -0500, Jeff Garzik wrote:
> On Sun, Feb 11, 2007 at 10:47:27AM -0800, Greg KH wrote:
> > It's in my queue and is on track to get in before 2.6.21-rc1 is out.
> 
> It breaks the build for everyone, please fast-forward the merging of
> this.

It's now in Linus's tree thanks to Andrew.
