Return-Path: <linux-kernel-owner+w=401wt.eu-S1761511AbZLPE1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511AbZLPE1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760375AbZLPE1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:27:09 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45102 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZLPE1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:27:04 -0500
Date: Wed, 16 Dec 2009 13:27:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: Fix test of unsigned in se7722_irq_demux()
Message-ID: <20091216042700.GB31265@linux-sh.org>
References: <4B27BB12.1050008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27BB12.1050008@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 05:36:34PM +0100, Roel Kluin wrote:
> se7722_fpga_irq[] is unsigned so the test does not work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
Applied, thanks.
