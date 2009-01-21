Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbZAUTO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbZAUTO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 14:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZAUTOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 14:14:48 -0500
Received: from kroah.org ([198.145.64.141]:54131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750769AbZAUTOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:14:48 -0500
Date: Wed, 21 Jan 2009 11:13:20 -0800
From: Greg KH <greg@kroah.com>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>
Subject: Re: [PATCH] hpilo open/close fix
Message-ID: <20090121191320.GA5232@kroah.com>
References: <20090112201837.GA19499@ldl.fc.hp.com> <20090121174146.GD3991@kroah.com> <92D64232F2316045B18937D5C9996B15225C8327D2@GVW1144EXB.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92D64232F2316045B18937D5C9996B15225C8327D2@GVW1144EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 07:05:03PM +0000, Altobelli, David wrote:
> > -----Original Message-----
> > From: Greg KH 
> > Am I supposed to be shepharding patches to drivers/misc/hpilo into the
> > kernel tree?  If so, I've been ignoring it, sorry.  Is there any
> > becides this one that you need to go in?
> > 
> 
> I appreciated your help when I first posted this driver, and you 
> are a general driver guy, so I copied you, but I didn't expect you 
> to take over shepherding patches into the tree for me.  I don't really 
> know how this process works, but I'm happy to copy any person/list that 
> will help me move code into the tree.  
> 
> I got an email that this patch was in -mm, but I don't know where it 
> went from there.

Ah, yeah, it looks like Andrew took this, which is good, it can go in
through there with no need for me to touch it.

Just cc: him on future patches to make sure he picks them up.

thanks,

greg k-h
