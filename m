Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXBEKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXBEKEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXBEKEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:04:31 -0500
Received: from mail.suse.de ([195.135.220.2]:37749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXBEKEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:04:31 -0500
Date: Mon, 5 Feb 2007 10:49:47 +0100
From: Stefan Seyfried <seife@suse.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070205094947.GA32384@suse.de>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <20070131021431.GR3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070131021431.GR3754@stusta.de>
X-Operating-System: openSUSE 10.2 (i586), Kernel 2.6.18.2-34-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 03:14:31AM +0100, Adrian Bunk wrote:
> On Tue, Jan 30, 2007 at 05:24:28PM -0800, Greg KH wrote:

> > What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> > that floppy.c is?  Do you want everyone just to run screaming from
> > kernel development never to be seen again?
> > 
> > :)
> 
> Other than with the ISA drivers example, at least everyone has the 
> hardware... ;-)

Wrong. I abandoned all floppy drives some years ago. I'd actually
vote for removing the floppy driver from the kernel completely.

Well, at work i probably have an USB floppy lying around somewhere,
but i doubt that it uses floppy.c ;-), 
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 
