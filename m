Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZDXUHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZDXUHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 16:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZDXUHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 16:07:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZDXUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 16:07:36 -0400
Date: Fri, 24 Apr 2009 20:59:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add armflash support for multiple blocks of flash
Message-ID: <20090424195928.GI28748@n2100.arm.linux.org.uk>
References: <20090423164110.31264.42300.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423164110.31264.42300.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 05:41:10PM +0100, Catalin Marinas wrote:
> This patch adds MTD concatenation support to integrator-flash.c for
> platforms with more than one block of flash memory (e.g. RealView
> PB11MPCore). The implementation is based on the sa1100-flash.c one.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

David, please merge via the mtd tree, thanks.
