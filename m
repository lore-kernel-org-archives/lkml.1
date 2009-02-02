Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZBBLnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZBBLnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZBBLnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:43:15 -0500
Received: from brick.kernel.dk ([93.163.65.50]:15013 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZBBLnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:43:14 -0500
Date: Mon, 2 Feb 2009 12:41:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bio.h: If they MUST be inlined, then use __always_inline
Message-ID: <20090202114119.GF30821@kernel.dk>
References: <1233533251-30240-1-git-send-email-albertito@blitiri.com.ar> <1233533251-30240-2-git-send-email-albertito@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233533251-30240-2-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01 2009, Alberto Bertogli wrote:
> bvec_kmap_irq() and bvec_kunmap_irq() comments say they MUST be inlined,
> so mark them as __always_inline.

Thanks Alberto, applied 1-2.

-- 
Jens Axboe

