Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZDHFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZDHFNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZDHFM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:12:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34164 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZDHFM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:12:58 -0400
Message-ID: <49DC324D.2040107@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 14:12:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [23/28] x86: MCE: Improve documentation
References: <20090407507.636692542@firstfloor.org> <20090407150806.76A7E1D0470@basil.firstfloor.org>
In-Reply-To: <20090407150806.76A7E1D0470@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Document that check_interval set to 0 means no polling.
> Noticed by Hidetoshi Seto
> 
> Also add a reference from boot options to the sysfs tunables
> 
> Cc: seto.hidetoshi@jp.fujitsu.com
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks!
H.Seto
