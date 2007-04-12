Return-Path: <linux-kernel-owner+w=401wt.eu-S2992524AbXDLNNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524AbXDLNNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992527AbXDLNNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:13:53 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45106 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992524AbXDLNNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:13:52 -0400
Date: Thu, 12 Apr 2007 22:10:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linuxsh-shmedia-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [KJ][PATCH] ROUND_UP macro cleanup in arch/sh64/kernel/pci_sh5.c
Message-ID: <20070412131013.GA14680@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Milind Arun Choudhary <milindchoudhary@gmail.com>,
	kernel-janitors@lists.osdl.org,
	linuxsh-shmedia-dev@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070412042150.GA11888@arun.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412042150.GA11888@arun.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:51:50AM +0530, Milind Arun Choudhary wrote:
> ROUND_UP macro cleanup, use ALIGN where ever appropriate.
> 
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
> 
Looks fine, thanks.

Acked-by: Paul Mundt <lethal@linux-sh.org>
