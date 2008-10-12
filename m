Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYJLWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYJLWVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYJLWVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 18:21:09 -0400
Received: from kroah.org ([198.145.64.141]:47161 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753474AbYJLWVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 18:21:08 -0400
Date: Sun, 12 Oct 2008 15:18:51 -0700
From: Greg KH <greg@kroah.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
Message-ID: <20081012221851.GB22940@kroah.com>
References: <87vdvyngni.fsf@hades.wkstn.nix> <20081012181700.GA21072@kroah.com> <87iqrxo924.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqrxo924.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 09:25:07PM +0100, Nix wrote:
> On 12 Oct 2008, Greg KH stated:
> > Perhaps some other kernel code is registering with that same major/minor
> > number, making it already present in sysfs.  Where does that sysfs file
> > link to before you load your driver?
> 
> It's not modular right now so it's sort of hard to tell. I'll rebuild it
> as a module and have a look (be a while before I can reboot though,
> other people are using this machine right now).

How about before you run that command on the machine?

thanks,

greg k-h
