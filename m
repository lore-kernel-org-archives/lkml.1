Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYF2PMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYF2PMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760840AbYF2PMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:12:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:57060 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbYF2PLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:11:55 -0400
Date: Mon, 30 Jun 2008 00:07:15 +0900
To: joerg.roedel@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 02/34] AMD IOMMU: add header file for driver data
 structures and defines
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1214508490-29683-3-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-3-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080629235410O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:38 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds a header file local to the AMD IOMMU driver with constants and
> data structures needed in the code.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  include/asm-x86/amd_iommu_types.h |  242 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 242 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-x86/amd_iommu_types.h

Is necessary to make this file visible to everyone by putting this in
include/asm?

