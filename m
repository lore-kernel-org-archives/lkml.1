Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZFCP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZFCP14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbZFCP1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:27:16 -0400
Received: from kroah.org ([198.145.64.141]:39108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbZFCP1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:27:11 -0400
Date: Wed, 3 Jun 2009 07:59:22 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>,
       GeunSik Lim <leemgs1@gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
	trivial tree
Message-ID: <20090603145922.GC30890@kroah.com>
References: <20090603171312.b80e30bb.sfr@canb.auug.org.au> <alpine.LNX.2.00.0906031007510.7457@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0906031007510.7457@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 10:08:58AM +0200, Jiri Kosina wrote:
> On Wed, 3 Jun 2009, Stephen Rothwell wrote:
> 
> > Today's linux-next merge of the driver-core tree got a conflict in
> > Documentation/trace/ftrace.txt between commit
> > 9976d9daf91d146724ad9c336f74c60d2195c386 ("trivial: Miscellaneous
> > documentation typo fixes") from the trivial tree and commit
> > b6b8b2b9588b3e09fea0da0e86f6b8bcba827b65 ("debugfs: Fix terminology
> > inconsistency of dir name to mount debugfs filesystem") from the
> > driver-core tree.
> > 
> > The latter removes the text that is patched by the former.  I just used
> > the driver-core version.  I suggest that the part of the trivial tree
> > patch that touches this file be dropped.
> 
> Correct, the patch in trivial queue got obsoleted by the driver-core one. 
> I have just dropped the version I had.

Great, thanks for doing this.

greg k-h
