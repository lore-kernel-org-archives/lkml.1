Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854Ab0ASVSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0ASVSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767Ab0ASVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:18:22 -0500
Received: from kroah.org ([198.145.64.141]:53479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab0ASVSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:18:18 -0500
Date: Tue, 19 Jan 2010 12:59:35 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: manual merge of the staging tree with the mips tree
Message-ID: <20100119205935.GB10928@kroah.com>
References: <20100118185351.3c6b719f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118185351.3c6b719f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:53:51PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/sm7xx/smtc2d.c drivers/staging/sm7xx/smtc2d.h between
> commit 8cdfa0e5f204ee97d27f742ebd207f4de8ca2984 ("Loongson: Change the
> Email address of Wu Zhangjin") from the mips tree and commit
> 1467bbc532da8c044e57706db232efe616ae5b00 ("staging: sm7xx: remove the
> buggy 2D acceleration support") from the staging tree.
> 
> I just removed the 2 files (as was done in the staging tree).

Thanks, that's the correct patch.

greg k-h
