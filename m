Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbXLUVjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbXLUVjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXLUVjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:39:39 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27285 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbXLUVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:39:38 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <476C3285.2060502@am.sony.com>
Date: Fri, 21 Dec 2007 13:39:17 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org
Subject: [announce] PS3 Linux Distributor's Starter Kit (v1.5.1) released
References: <4581CA0C.20102@am.sony.com>
In-Reply-To: <4581CA0C.20102@am.sony.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2007 21:39:18.0501 (UTC) FILETIME=[F0CEB950:01C84419]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those interested, an updated PS3 Linux Distributor's Starter Kit (v1.5.1)
was released.

This is a bug-fix release that only updates kboot and the linux kernel
with the fix for the PS3 system update 2.10 frame buffer bug.

The CD-ROM iso image is here (171 MiB):

  ftp://ftp.infradead.org/pub/Sony-PS3/CELL-Linux-CL_20071220-ADDON.iso
  http://ftp.uk.linux.org/pub/linux/Sony-PS3/CELL-Linux-CL_20071220-ADDON.iso

I extracted files are here for convenient browsing:

  http://www.kernel.org/pub/linux/kernel/people/geoff/cell/CELL-Linux-CL_20071220-ADDON

An updated kboot image is here:

 http://www.kernel.org/pub/linux/kernel/people/geoff/cell/kboot-20071220.bld

More info on the 2.10 frame buffer bug is here:

  http://ozlabs.org/pipermail/cbe-oss-dev/2007-December/003727.html

-Geoff

