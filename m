Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbXBFPAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbXBFPAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbXBFPAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:00:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXBFO77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:59:59 -0500
Date: Tue, 6 Feb 2007 09:57:18 -0500
From: Dave Jones <davej@redhat.com>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: Stefan Seyfried <seife@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070206145718.GC1828@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sunil Naidu <akula2.shark@gmail.com>,
	Stefan Seyfried <seife@suse.de>, Adrian Bunk <bunk@stusta.de>,
	Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
	linux-kernel@vger.kernel.org
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de> <20070131012428.GA31759@kroah.com> <20070131021431.GR3754@stusta.de> <20070205094947.GA32384@suse.de> <8355959a0702060537jbd96e96sc10772f72f9491b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8355959a0702060537jbd96e96sc10772f72f9491b3@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 07:07:50PM +0530, Sunil Naidu wrote:
 > On 2/5/07, Stefan Seyfried <seife@suse.de> wrote:
 > > On Wed, Jan 31, 2007 at 03:14:31AM +0100, Adrian Bunk wrote:
 > > > On Tue, Jan 30, 2007 at 05:24:28PM -0800, Greg KH wrote:
 > >
 > > Wrong. I abandoned all floppy drives some years ago. I'd actually
 > > vote for removing the floppy driver from the kernel completely.
 > 
 > I don't think time has come for that yet, still millions of people do
 > use Floppy on Linux ;-)
 > Maybe by 2.6.30 or so...

The release of any new kernel doesn't make all existing hardware
on the planet stop working.  I still get requests to enable
drivers in the Fedora kernel for 10 year old ISA sound cards.

In some parts of the world, buying a new computer isn't an option.
One of Linux's strengths is that we keep working on old hardware
without forcing the user to upgrade their system every time
like certain commercial OS's.

		Dave

-- 
http://www.codemonkey.org.uk
