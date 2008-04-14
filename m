Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbYDNP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbYDNP3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYDNP3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:29:25 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:1259 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYDNP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:29:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Mon, 14 Apr 2008 17:29:18 +0200
User-Agent: KMail/1.9.9
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <20080414135214.GC7385@csclub.uwaterloo.ca> <20080414145607.3ae98a6f@core>
In-Reply-To: <20080414145607.3ae98a6f@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141729.20160.elendil@planet.nl>
X-OriginalArrivalTime: 14 Apr 2008 15:29:22.0656 (UTC) FILETIME=[508ECE00:01C89E44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Alan Cox wrote:
> > > 2) it is only loaded if an ISA bus is present
>
> All PC class systems have an ISA bus, it may be on the main board and
> called LPC but it is there.

The actual test is if /sys/bus/isa exists, which it does not at least on my 
current PC class desktop (em64t).
My 4 year old laptop (i386) does have it though.
