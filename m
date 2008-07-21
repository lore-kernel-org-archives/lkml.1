Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYGUUgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYGUUgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYGUUgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:36:25 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:44154 "EHLO
	critter.phunnypharm.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYGUUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:36:25 -0400
X-Greylist: delayed 2048 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 16:36:25 EDT
Subject: Re: ACPI: ACPI_CUSTOM_DSDT_INITRD option
From: Ben Collins <bcollins@swissdisk.com>
To: "Joshua C." <joshuacov@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5f6f8c5f0807211257j668535eam873275afc2040f73@mail.gmail.com>
References: <5f6f8c5f0807211257j668535eam873275afc2040f73@mail.gmail.com>
Content-Type: text/plain
Organization: SwissDisk
Date: Mon, 21 Jul 2008 16:02:13 -0400
Message-Id: <1216670533.7585.181.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 21:57 +0200, Joshua C. wrote:
> 2008/7/21 Ben Collins <ben.collins@canonical.com>:
> >
> > Could you rebase it on latest git (lots of fuzz)? Other than that, it
> > looks good to me. We've been carrying this patch forever, so would be
> > nice to have it applied upstream finally.
> >
> >
> 
> I tried the current patch (acpi-dsdt-initrd-v0.9a-2.6.25.patch) with
> fedora kernel-2.6.27-0.161.rc0.git6.fc10 which is git6 and it compiled
> without any problems. I didn't modify anything on the patch. so it
> should be "production" ready in its current state, shouldn't it? Maybe
> this time it can make its way upstream.

I didn't have any problems with it either, but I would hate for some
fuzz to keep it from getting accepted :)

