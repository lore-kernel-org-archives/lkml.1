Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYDTU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYDTU2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYDTU22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:28:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36458
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755276AbYDTU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:28:27 -0400
Date: Sun, 20 Apr 2008 13:28:29 -0700 (PDT)
Message-Id: <20080420.132829.220464348.davem@davemloft.net>
To: bunk@kernel.org
Cc: aacraid@adaptec.com, James.Bottomley@HansenPartnership.com,
       wli@holomorphy.com, sparclinux@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080420201443.GB14788@cs181133002.pp.htv.fi>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi>
	<20080415.003910.50277238.davem@davemloft.net>
	<20080420201443.GB14788@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 20 Apr 2008 23:14:43 +0300

> On Tue, Apr 15, 2008 at 12:39:10AM -0700, David Miller wrote:
> > From: Adrian Bunk <bunk@kernel.org>
> >...
> > > <--  snip  -->
> > > 
> > >   MODPOST 1741 modules
> > > ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> > > ...
> > > make[2]: *** [__modpost] Error 1
> > > 
> > > <--  snip  -->
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > Applied, thanks Adrian.
> 
> Please drop - aacraid no longer uses it in 2.6.26.

Ok, will do.
