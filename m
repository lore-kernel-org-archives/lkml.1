Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbYCaHTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbYCaHTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYCaHTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:19:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:47564 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752832AbYCaHTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:19:13 -0400
Date: Mon, 31 Mar 2008 16:19:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove include/asm-sh/floppy.h
Message-ID: <20080331071905.GB16398@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080330225343.GI28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330225343.GI28445@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 01:53:43AM +0300, Adrian Bunk wrote:
> This patch removes the unused include/asm-sh/floppy.h 
> (ARCH_MAY_HAVE_PC_FDC was not enabled).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Applied, thanks.
