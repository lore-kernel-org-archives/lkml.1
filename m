Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZFKBvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZFKBvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZFKBvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:51:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:55954 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbZFKBvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:51:02 -0400
Cc: Leon Woestenberg <leon@sidebranch.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <6567F141-5B17-440E-B052-95E20276B222@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: leon.woestenberg@gmail.com
In-Reply-To: <4a2a9611.06c8100a.49ae.ffff88e4@mx.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH v2] Add MSI interrupts to DTS of MPC8315E-RDB
Date: Wed, 10 Jun 2009 20:50:54 -0500
References: <4a2a9611.06c8100a.49ae.ffff88e4@mx.google.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6, 2009, at 11:15 AM, leon.woestenberg@gmail.com wrote:

> The PCIe MSI interrupts are missing from the device tree source, and
> thus were not enabled. This patch adds them.
>
> v2 of the patch fixes inconsistent white space, reported by David  
> Gibson.
>
> Tested to work on MPC8315E-RDB with custom FPGA PCIe device.
>
> Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
> Tested-by: Leon Woestenberg <leon@sidebranch.com>

applied to next.

- k
