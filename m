Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXBWGxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXBWGxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXBWGxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:53:32 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50289 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXBWGxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:53:31 -0500
Date: Fri, 23 Feb 2007 01:53:20 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] unionfs: fix slab abuses with krealloc
Message-ID: <20070223065320.GA6943@filer.fsl.cs.sunysb.edu>
References: <Pine.LNX.4.64.0702221440230.14523@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702221440230.14523@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 02:41:16PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This changes unionfs to use krealloc() for reallocating memory so that
> we don't need to play tricks with slab internals.
> 
> Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

I guess I should have Acked both patches...

Acked-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
