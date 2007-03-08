Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXCHJsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXCHJsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030520AbXCHJsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:48:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47780 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519AbXCHJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:48:36 -0500
Subject: Re: [PATCH] MTD: Correct misspelled preprocessor variable
	"MTD_NAND_DISKONCHIP_BBTWRITE".
From: David Woodhouse <dwmw2@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0703071831120.3827@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703071831120.3827@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 09:48:32 +0000
Message-Id: <1173347312.3461.395.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 18:33 -0500, Robert P. J. Day wrote:
>   Replace the apparently misspelled preprocessor variable
> "MTD_NAND_DISKONCHIP_BBTWRITE" with the correct form
> "CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE".
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com> 

Applied; thanks.

-- 
dwmw2

