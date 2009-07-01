Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZGAEu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZGAEu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZGAEuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:50:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55045 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZGAEuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:50:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19018.59934.340505.808753@cargo.ozlabs.ibm.com>
Date: Wed, 1 Jul 2009 14:46:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/perf_counter: POWER7 has alternate PR/HV bits
In-Reply-To: <20090701030701.GI3563@kryten>
References: <20090701030701.GI3563@kryten>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard writes:

> POWER7 has the same PR/HV bit layout as POWER6, so set the flag.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Paul Mackerras <paulus@samba.org>
