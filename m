Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZAMPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZAMPsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAMPsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:48:32 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:65334 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751247AbZAMPsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:48:31 -0500
Date: Tue, 13 Jan 2009 16:48:16 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH] dmatest: Use custom map/unmap for destination buffer
Message-ID: <20090113164816.7f7d3d31@hskinnemoen-d830>
In-Reply-To: <1231860880-6277-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1231860880-6277-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> The dmatest driver should use DMA_BIDIRECTIONAL on the destination buffer
> to ensure that the poison values are written to RAM and not just written
> to cache and discarded.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
