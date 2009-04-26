Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZDZPVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZDZPVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZDZPVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:21:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34371 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZDZPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BpX4U6H4CMYdn5EYiHGHwYAVdOo4VgHxo76f0zJrPvkIgLx/bp2vzc1T8XWa6vlrZt
         dlL6f8K+/vlnPjs6n4BnwVG94QdbzKD+IBuUCEDldFHkjtxUV2HVJlE7LfkHdaEEylMC
         0EIpT2YTgIMq0qkMUBuWfvTjTQyAL19scC9dY=
Subject: Re: SDHCI driver runnining in aspire one, allows to write to R/O
 SD cards
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: sdhci-devel@lists.ossman.eu, pierre@ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1240524632.20871.0.camel@maxim-laptop>
References: <1240219764.13640.5.camel@maxim-laptop>
	 <49ED0865.9030603@gmail.com>  <1240524632.20871.0.camel@maxim-laptop>
Content-Type: text/plain
Date: Sun, 26 Apr 2009 18:21:16 +0300
Message-Id: <1240759276.10972.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 01:10 +0300, Maxim Levitsky wrote:
> On Mon, 2009-04-20 at 17:42 -0600, Robert Hancock wrote:
> > Maxim Levitsky wrote:
> > > Hi,
> > > 
> > > I am an owner of aspire one, and it has a card reader.
> > > when I take a sd card, and pull down the protection tab, it still allows
> > > to write to the card (I tested with my main notebook that indeed, it did
> > > write there).
> > > 
> > > My main notebook, acer aspire 5720, doesn't have this problem.
> > > Kernel version in use is 2.6.28 vanilla, but this did happen in former
> > > version as well.
> > > 
> > > 
> > > Attached lspci, on acer one.
> > 
> > Do you know if it worked in any kernel version or OS? It's known that 
> > some SD card readers are too cheap to actually implement the 
> > write-protect detection.
> 
> I'll test in windows, but in linux it never did work.
> 
> Best regards,
> 	Maxim Levitsky
> 
Yep, works fine in windows.
Tested with and without lock tab.


Best regards,
	Maxim Levitsky

