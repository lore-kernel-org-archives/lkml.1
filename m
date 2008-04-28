Return-Path: <linux-kernel-owner+w=401wt.eu-S935558AbYD1Rka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935558AbYD1Rka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbYD1RkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:40:04 -0400
Received: from oss.sgi.com ([192.48.170.157]:35443 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765660AbYD1RkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:40:03 -0400
Date: Mon, 28 Apr 2008 18:39:39 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mips: unexport __kmap_atomic_to_page
Message-ID: <20080428173939.GA1383@linux-mips.org>
References: <20080421085137.GF26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421085137.GF26897@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:51:37AM +0300, Adrian Bunk wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Mon, 21 Apr 2008 11:51:37 +0300
> To: ralf@linux-mips.org
> Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
> Subject: [2.6 patch] mips: unexport __kmap_atomic_to_page
> Content-Type: text/plain; charset=utf-8
> 
> This patch removes the no longer used export of __kmap_atomic_to_page.

Thanks, applied.

  Ralf
