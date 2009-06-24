Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbZFXM6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbZFXM6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZFXM5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:57:51 -0400
Received: from kroah.org ([198.145.64.141]:60102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZFXM5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:57:50 -0400
Date: Wed, 24 Jun 2009 05:52:26 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Joel Becker <Joel.Becker@oracle.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Len Brown <lenb@kernel.org>, Avi Kivity <avi@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>, Boaz Harrosh <bharrosh@panasas.com>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: Main things left in linux-next
Message-ID: <20090624125226.GA24328@kroah.com>
References: <20090624164617.b7c49974.sfr@canb.auug.org.au> <20090624172735.9b500674.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624172735.9b500674.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 05:27:35PM +1000, Stephen Rothwell wrote:
> devtmpfs from the driver-core tree (hmmm?)

this will remain until .32.

thanks,

greg k-h
