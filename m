Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYJIR6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYJIR6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760543AbYJIR6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:58:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:10099 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760533AbYJIR6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:58:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,384,1220252400"; 
   d="scan'208";a="57485830"
Message-ID: <48EE463F.5000704@intel.com>
Date: Thu, 09 Oct 2008 10:58:23 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Intel G33 chipset support on 2.4.xx ?
References: <20081009150100.GC5800@hohwie.com>
In-Reply-To: <20081009150100.GC5800@hohwie.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 17:58:23.0641 (UTC) FILETIME=[9F545890:01C92A38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Hohwieler wrote:
> Unfortunately I don't have any hardware to test it ...
> 
> So, is the Intel G33 chipset fully supported by any
> linux-2.4.xx release?

why would it?

2.4 has been in maintenance mode since before this motherboard even came out, so
no, obviously this is not the case.

some stuff will work (hdd, cpus, usb), but most of the peripherals will not or
only offer basic functionality (gfx, ethernet)

Auke
