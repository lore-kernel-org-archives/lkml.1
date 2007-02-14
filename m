Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXBNTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXBNTri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932207AbXBNTri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:47:38 -0500
Received: from ns1.suse.de ([195.135.220.2]:38902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbXBNTrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:47:37 -0500
Date: Wed, 14 Feb 2007 11:45:54 -0800
From: Greg KH <gregkh@suse.de>
To: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH debugfs: implement symbolic links
Message-ID: <20070214194554.GC8603@suse.de>
References: <20070214012732.GA9023@suse.de> <OF3AFCA38F.FEB02E68-ONC1257282.002B8139-C1257282.002C41B5@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF3AFCA38F.FEB02E68-ONC1257282.002B8139-C1257282.002C41B5@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:03:24AM +0100, Peter 1 Oberparleiter wrote:
> Greg KH <gregkh@suse.de> wrote on 14.02.2007 02:27:32:
> > On Tue, Feb 13, 2007 at 12:13:54PM +0100, Peter Oberparleiter wrote:
> > > This function can be useful
> > > for people moving functionality from /proc to debugfs (e.g. the
> > > gcov-kernel patch).
> > 
> > You aren't really creating debugfs symlinks from /sys/kernel/debug/ to
> > the /proc directory are you?  That's pretty insane...
> 
> Interesting idea :) But I was thinking more along the lines of replacing
> existing /proc files and symlinks with files and links in debugfs.

Ah, ok, that sounds much saner :)

thanks,

greg k-h
