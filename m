Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYFIMdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYFIMdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYFIMdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:33:43 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64521 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756136AbYFIMdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:33:43 -0400
Date: Mon, 9 Jun 2008 13:33:29 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Chen, Huacai" <huacai.chen@intel.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch]modify the MIPS CPU classfication
In-Reply-To: <42DFA526FC41B1429CE7279EF83C6BDC01404341@pdsmsx415.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.55.0806091330560.26593@cliff.in.clinika.pl>
References: <42DFA526FC41B1429CE7279EF83C6BDC01404341@pdsmsx415.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Chen, Huacai wrote:

> The company ID of Loongson1/Loongson2 is PRID_COMP_LEGACY, but they were
> classified in the list whoes company ID is  PRID_COMP_MIPS. This patch
> move them to the right place.

 Note the list is currently sorted numerically and meant to stay such.  
Please update your patch accordingly.

  Maciej
