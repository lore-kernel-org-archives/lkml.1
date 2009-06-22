Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZFVPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZFVPQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZFVPQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:16:06 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:64798 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZFVPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:16:04 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
Date: Mon, 22 Jun 2009 17:16:04 +0200
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <200906221604.17915.elendil@planet.nl> <200906221639.52205.bzolnier@gmail.com>
In-Reply-To: <200906221639.52205.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906221716.05983.elendil@planet.nl>
X-OriginalArrivalTime: 22 Jun 2009 15:16:06.0446 (UTC) FILETIME=[5D424CE0:01C9F34C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Bartlomiej Zolnierkiewicz wrote:
> I promised to look into it but I still need a identify block content to
> tell more (you can add #define DEBUG to the ide-probe.c so we will get
> id before and after changing of transfer mode settings):

probing for hdd: present=0, media=32, probetype=ATA
probing for hdd: present=0, media=32, probetype=ATAPI
hdd: dumping identify data
c085 0000 0000 0000 0000 0000 0000 0000
0000 0000 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 0000 0000 0000 3841
2045 2020 2020 4443 522d 4d4f 3520 5836
412f 484b 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 0000
0000 000f 0000 0003 0002 0200 0000 0000
0000 0000 0000 0000 0000 0000 0701 0701
0300 7800 7800 5802 7800 0000 0000 0000
0000 0000 0000 3030 3030 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0700 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
