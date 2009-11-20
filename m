Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZKTSb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZKTSb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZKTSb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:31:59 -0500
Received: from kroah.org ([198.145.64.141]:46723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZKTSb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:31:58 -0500
Date: Fri, 20 Nov 2009 10:27:31 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Patrick Johnson <teknotus@teknot.us>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: linux-next: manual merge of the staging tree with the pcmcia
 tree
Message-ID: <20091120182731.GA4804@kroah.com>
References: <20091109181527.a42431bc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109181527.a42431bc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 06:15:27PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/comedi/drivers/ni_mio_cs.c between commit
> 4e338b7f55b4c30e60fa3fa9ff3d21e930f40116 ("pcmcia/staging: update comedi
> drivers") from the pcmcia tree and commit
> bd7881ee58045b4b684f4400b24081656e0c6986 ("Staging: comedi: ni_mio_cs.c:
> coding style cleanup") from the staging tree.
> 
> I fixed it up (mainly using the pcmcia tree version when there was a
> clash) and can carry the fix as necessary.

Thanks for the fix.

greg k-h
