Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbYA0NlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbYA0NlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 08:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYA0Nky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 08:40:54 -0500
Received: from smtp01.pevnalinka.cz ([89.31.40.2]:61791 "EHLO
	mail.pevnalinka.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753198AbYA0Nkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 08:40:53 -0500
Message-ID: <479C8A0E.40804@monstr.eu>
Date: Sun, 27 Jan 2008 14:41:34 +0100
From: Michal Simek <monstr@monstr.eu>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 17/52] [microblaze] checksum support
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu> <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu> <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu> <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu> <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu> <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu> <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu> <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu> <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu> <Pine.LNX.4.64.0801271256300.6736@anakin>
In-Reply-To: <Pine.LNX.4.64.0801271256300.6736@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,
> So basically this is a copy of arch/m68knommu/lib/checksum.c, with some
> checkpatch.pl fixes but without the sparse fixes?
> Furthermore, it's just plain C, so maybe we need a common one that can
> be shared by multiple archs?
>
> Gr{oetje,eeting}s,
> 						Geert
>   
I have no sparse errors and warning in checksum.c file.

Michal Simek
www.monstr.eu
