Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZKTScP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZKTScP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZKTScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:32:14 -0500
Received: from kroah.org ([198.145.64.141]:46738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZKTScB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:32:01 -0500
Date: Fri, 20 Nov 2009 10:29:40 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Massey <bart@cs.pdx.edu>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: manual merge of the staging tree with the pcmcia
 tree
Message-ID: <20091120182940.GC4804@kroah.com>
References: <20091109181534.c844974d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109181534.c844974d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 06:15:34PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/comedi/drivers/ni_labpc_cs.c between commit
> 4e338b7f55b4c30e60fa3fa9ff3d21e930f40116 ("pcmcia/staging: update comedi
> drivers") from the pcmcia tree and commits
> c22f24e5f0ed5a45e4b339577a1151c4bbb8977a ("Staging: comedi: ni_labpc_cs:
> added mandatory whitespace to comparison") and
> f195fbc2466c79cda709074fdbb969079e0787e0 ("Staging: comedi: ni_labpc_cs:
> wrapped long comments") from the staging tree.
> 
> I fixed it up (using the pcmcia tree version where there was a clash) and
> can carry the fix as necessary.

Thanks for the fixup.

greg k-h
