Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbZGJHzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbZGJHzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbZGJHza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:55:30 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:57733 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZGJHz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:55:29 -0400
Message-ID: <11512ed726f2d6754f46e76c7db191a8.squirrel@www.hardeman.nu>
In-Reply-To: <200907091538.21685.bjorn.helgaas@hp.com>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
    <737c7bd0a2f550d21d45b347d018a1ac.squirrel@www.hardeman.nu>
    <200907081052.20142.bjorn.helgaas@hp.com>
    <200907091538.21685.bjorn.helgaas@hp.com>
Date: Fri, 10 Jul 2009 09:55:27 +0200 (CEST)
Subject: Re: [PATCH 0/2] Winbond driver as PNP
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, "Len Brown" <lenb@kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, July 9, 2009 23:38, Bjorn Helgaas wrote:
> Here are two sample patches to show you what I was suggesting.  These
> apply on top of the two Winbond patches currently in -mm.

Thanks, great service :)

I'll test the patches as soon as I have time and access to the hardware.

One question though, the resulting patch series (if AKPM merges these
patches in addition to the existing ones and drops the patch adding
.shutdown to acpi_driver) will be git bisect unfriendly.

Should I roll two new patches instead to replace the three patches
currently in -mm?

-- 
David Härdeman

