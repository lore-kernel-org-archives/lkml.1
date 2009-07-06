Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZGFHVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZGFHVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZGFHVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:21:16 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:58974 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZGFHVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:21:15 -0400
Message-ID: <4A51A5E9.1030605@petalogix.com>
Date: Mon, 06 Jul 2009 09:21:13 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Linn <john.linn@xilinx.com>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: linux-next: manual merge of the suspend tree with the microblaze
 tree
References: <20090706140050.0dec74a2.sfr@canb.auug.org.au>
In-Reply-To: <20090706140050.0dec74a2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Rafael,
>
> Today's linux-next merge of the suspend tree got a conflict in
> arch/microblaze/include/asm/device.h between commit
> 19aff4132a289ec83ca6eee8b3db28855b9f06af ("microblaze: Adding
> dev_arch_data functions") from the microblaze tree and commit
> c959b4101b10723eeb190ef2e82765dd529c26b6 ("Driver Core: Add platform
> device arch data V3") from the suspend tree.
>
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.
>   
I'll revert this patch and I'll add it later.
Rafael you don't need to do any changes. I'll do them.
This John L patch is not important - just for any drivers which are not
in mainline.
I'll add it later.

Thanks,
Michal


> P.S. Michal, that microblaze commit has an invalid email address for the
> Author (John Linn <linnj@xaqlinnj41.(none)>).
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

