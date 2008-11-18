Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYKRNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYKRNvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKRNvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:51:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:28179 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbYKRNvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:51:32 -0500
Message-ID: <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
Date: Tue, 18 Nov 2008 11:51:30 -0200
From: "Sergio Luis" <sergio@larces.uece.br>
To: "Stian Jordet" <liste@jordet.net>
Subject: Re: Slowness with new pc
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1226760254.5089.11.camel@chevrolet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226760254.5089.11.camel@chevrolet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 12:44 PM, Stian Jordet <liste@jordet.net> wrote:
> Hi!
>
> This fall I built myself a new computer. It's a dual cpu quad core xeon
> (E5405) on a Supermicro X7DWA-N motherboard. It has 8GB 800mhz ram, and
> a Supermicro AOC-USAS-S8iR RAID SAS controller, with a pair of Fujitsu
> MBA3073RC disks in raid 0. Should be pretty fast, but it isn't. In daily
> use it feels just about the same as my old Dual P3 1ghz with a single
> SCSI disk. Has to wait a couple of seconds before the gnome menu appears
> after I've clicked on it, for instance. But with operations involving
> heavy disk use, it's extremely slow! For instance, unpacking the bzipped
> 2.6.27.6 kernel takes 6:40 minutes, while compiling it takes a mere
> 5:13. I thought I had a hardware problem (still not ruling that out), so
> I tried to install Vista, and then everything was blazingly fast. I have
> no clue where to look, but a static benchmark like hdparm gives me a
> throughput of 235MB/s on the raid 0 array. Could it be
> filesystem-related? I'm using XFS (always have)...
>
> Please cc me on any replies.
>
> Regards,
> Stian
>

Hello,
please post your config and dmesg output. It might help people try to
identify something wrong.
