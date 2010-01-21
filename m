Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232Ab0AUVIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0AUVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200Ab0AUVIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:08:32 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:57755 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0AUVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:08:32 -0500
Date: Thu, 21 Jan 2010 15:07:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/36] x86: check range in update range
In-Reply-To: <4B58C0E8.2050205@kernel.org>
Message-ID: <alpine.DEB.2.00.1001211507110.19009@router.home>
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-3-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001211443030.13130@router.home> <4B58C0E8.2050205@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Yinghai Lu wrote:

> On 01/21/2010 12:43 PM, Christoph Lameter wrote:
> > On Wed, 20 Jan 2010, Yinghai Lu wrote:
> >
> >> -v2: update comments
> >
> > Dont see any comments being added.
> ----------------------------
> so later could use it with 32bit amd_bus/intel_bus, and it could have cap_resource.
> ----------------------------

Ah the description.

