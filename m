Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbZCYQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbZCYQ1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZCYQ1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:27:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:40958 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZCYQ1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:27:05 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LinuxPPC Linux-LINUXPPC <LINUXPPC@freescale.com>
Message-Id: <98251C63-0A58-4C8A-B442-48A08CF318BC@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090323224615.cd29edfd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: 2.6.30 -mm merge plans
Date: Wed, 25 Mar 2009 11:24:01 -0500
References: <20090323224615.cd29edfd.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 24, 2009, at 12:46 AM, Andrew Morton wrote:

> Merge
>
>    spi_mpc83xx-fix-sparse-warnings.patch
>    spi_mpc83xx-rework-chip-selects-handling.patch
>    spi_mpc83xx-add-of-platform-driver-bindings.patch
>    powerpc-add-mmc-spi-slot-bindings.patch
>    powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e- 
> rdb.patch
>    powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb- 
> boards.patch

Andrew,

I can pick these up via the powerpc.git tree since they are for a PPC  
specific SPI driver.  I intended to pick the last three patches once  
the first three went in on the driver side.  But I can deal with all 6  
if you want me to.

- k
