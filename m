Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXF1XgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXF1XgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbXF1XgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:36:11 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:41780 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbXF1XgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:36:10 -0400
Date: Thu, 28 Jun 2007 19:25:13 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Wrong cache size reported on Q6600
Message-ID: <20070628232513.GL2784@fattire.cabal.ca>
References: <200706290931.45355.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706290931.45355.kernel@kolivas.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 09:31:44AM +1000, Con Kolivas wrote:
> This is a Q6600 which has cache size of 8 MB. Unless it's reporting each 
> half's effective L2, I think it should be reporting 8192 instead of 4096.
> 

Each pair of cores appears to get 4MB of L2, according to the product
brief PDF on Intel's website.

Cheers, Kyle
