Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZFCIJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZFCIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbZFCII6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:08:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbZFCII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:08:57 -0400
Date: Wed, 3 Jun 2009 10:08:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>,
       GeunSik Lim <leemgs1@gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the trivial
 tree
In-Reply-To: <20090603171312.b80e30bb.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0906031007510.7457@wotan.suse.de>
References: <20090603171312.b80e30bb.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the driver-core tree got a conflict in
> Documentation/trace/ftrace.txt between commit
> 9976d9daf91d146724ad9c336f74c60d2195c386 ("trivial: Miscellaneous
> documentation typo fixes") from the trivial tree and commit
> b6b8b2b9588b3e09fea0da0e86f6b8bcba827b65 ("debugfs: Fix terminology
> inconsistency of dir name to mount debugfs filesystem") from the
> driver-core tree.
> 
> The latter removes the text that is patched by the former.  I just used
> the driver-core version.  I suggest that the part of the trivial tree
> patch that touches this file be dropped.

Correct, the patch in trivial queue got obsoleted by the driver-core one. 
I have just dropped the version I had.

Thanks,

-- 
Jiri Kosina
SUSE Labs
