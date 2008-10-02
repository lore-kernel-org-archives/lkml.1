Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYJBTHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYJBTHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYJBTHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:07:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44776 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbYJBTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:07:16 -0400
Date: Thu, 2 Oct 2008 20:06:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: wrong usage of MAX_DMA_ADDRESS in bootmem.h
Message-ID: <20081002190657.GB12718@flint.arm.linux.org.uk>
References: <alpine.LFD.2.00.0809301409230.3635@xanadu.home> <20080930184411.GJ15911@flint.arm.linux.org.uk> <alpine.LFD.2.00.0809301513260.3635@xanadu.home> <48E2846A.4030802@linux-foundation.org> <20080930201224.GL15911@flint.arm.linux.org.uk> <48E3680E.6040703@linux-foundation.org> <20081001140607.GA22031@flint.arm.linux.org.uk> <48E38E30.70901@linux-foundation.org> <20081001150258.GB22031@flint.arm.linux.org.uk> <48E4FB85.2040204@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E4FB85.2040204@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 11:49:09AM -0500, Christoph Lameter wrote:
> Right. Lets do it. MAX_DMA32 needs to be changed too.
> 
> While you are at it: Could you make the association with the zones clearer?
> 
> MAX_ZONE_DMA32_ADDRESS MAX_ZONE_DMA_ADDRESS, MAX_ZONE_DMA_PFN,
> MAX_ZONE_DMA32_PFN ....

If you want me to do it, expect it in about 6 to 12 months time.
