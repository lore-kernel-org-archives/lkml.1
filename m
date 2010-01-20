Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188Ab0ATTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0ATTvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703Ab0ATTvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:51:21 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:46446 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0ATTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:51:20 -0500
Date: Wed, 20 Jan 2010 13:50:16 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/37] x86: check range in update range
In-Reply-To: <4B575C07.8080002@kernel.org>
Message-ID: <alpine.DEB.2.00.1001201349540.15175@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-3-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191055070.22304@router.home> <4B575C07.8080002@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Yinghai Lu wrote:

> On 01/19/2010 08:56 AM, Christoph Lameter wrote:
> > On Fri, 15 Jan 2010, Yinghai Lu wrote:
> >
> >> fend off wrong range
> >
> > Why is it ok now to call these functions with start >= end? Bootmem
> > compatibilty?
>
> and amd_bus/intel_bus etc will be use 32bit etc

Can you be more detailed?

