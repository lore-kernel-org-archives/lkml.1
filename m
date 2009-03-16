Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbZCPL25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbZCPL25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbZCPL2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:28:48 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42485 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZCPL2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:28:47 -0400
Date: Mon, 16 Mar 2009 20:24:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Linux-sh <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH] dmaengine: sh: Add support DMA-Engine driver for DMA of SuperH
Message-ID: <20090316112436.GH21433@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
	Linux-sh <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
	maciej.sosnowski@intel.com, dan.j.williams@intel.com
References: <49B8AF67.8080309@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8AF67.8080309@renesas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:44:55PM +0900, Nobuhiro Iwamatsu wrote:
> This supports DMA-Engine driver for DMA of SuperH.
> This supported all DMA channels, and it was tested in SH7722/SH7780.
> This can not use with SH DMA API and can control this in Kconfig.
> 
> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

The updated version looks ok to me. If no one else has any issues with
it, and someone from the dmaengine side wants to provide an Acked-by, I
can take it through my tree.
