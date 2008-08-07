Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYHGNkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYHGNkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYHGNkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:40:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55175 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbYHGNkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:40:01 -0400
From: John Keller <jpk@sgi.com>
Message-Id: <200808071339.m77DduCA517552@fcbayern.americas.sgi.com>
Subject: Re: [RESEND] [PATCH] x86: Allow MMCONFIG above 4GB on x86_64
To: mingo@elte.hu (Ingo Molnar)
Date: Thu, 7 Aug 2008 08:39:55 -0500 (CDT)
Cc: jpk@sgi.com (John Keller), linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, yhlu.kernel@gmail.com (Yinghai Lu),
       hpa@zytor.com (H. Peter Anvin), tglx@linutronix.de (Thomas Gleixner)
In-Reply-To: <20080731104510.GI488@elte.hu> from "Ingo Molnar" at Jul 31, 2008 12:45:11 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> * John Keller <jpk@sgi.com> wrote:
> 
> > Just checking on the status of this patch.
> > If there are no issues, please apply.
> 
> > SGI UV will have MMCFG base addresses that are greater than 4GB (32 bits).
> 
> applied to tip/x86/uv, thanks John.
> 
> 	Ingo


Thanks.

Will this patch be pushed into 2.6.27?

If not, how do I make this happen?

Thanks again,
John
