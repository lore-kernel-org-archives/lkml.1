Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYBRVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYBRVhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYBRVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:36:56 -0500
Received: from www.tglx.de ([62.245.132.106]:42226 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYBRVg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:36:56 -0500
Date: Mon, 18 Feb 2008 22:36:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>
Subject: Re: [PATCH] x86/mtrr: fix kernel-doc missing notation
In-Reply-To: <20080218131044.d0397c84.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.00.0802182235350.7583@apollo.tec.linutronix.de>
References: <20080218131044.d0397c84.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix mtrr kernel-doc warning:
> Warning(linux-2.6.24-git12//arch/x86/kernel/cpu/mtrr/main.c:677): No description found for parameter 'end_pfn'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied. Thanks,

	 tglx
