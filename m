Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYIXScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYIXScU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIXScN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:32:13 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:64674 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYIXScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:32:12 -0400
Message-ID: <48DA8796.5020304@freescale.com>
Date: Wed, 24 Sep 2008 13:31:50 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Dan Williams <dan.j.williams@intel.com>, Li Yang <leoli@freescale.com>,
       zw@zh-kernel.org, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled
 as a module
References: <1221837088-19539-1-git-send-email-timur@freescale.com> <47B7FAA6-434C-440A-B55D-03C9882809CE@kernel.crashing.org>
In-Reply-To: <47B7FAA6-434C-440A-B55D-03C9882809CE@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:

> Dan, any update on this patch?

I'm going to post a new version.  This whole thing is more complicated than I
thought.

-- 
Timur Tabi
Linux kernel developer at Freescale
