Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYKMVKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYKMVKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYKMVKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:10:04 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:36533 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYKMVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:10:03 -0500
Date: Thu, 13 Nov 2008 15:09:32 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 0/7] cpu alloc stage 2
In-Reply-To: <Pine.LNX.4.64.0811130827450.19293@quilx.com>
Message-ID: <Pine.LNX.4.64.0811131507300.10624@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081112175717.4a1fd679.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0811121406550.31606@quilx.com> <20081113103510.4a6a1d3a.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0811130827450.19293@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I put a cpu_alloc_stage2 onto the git archive

git.kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2

Not sure if I should dare to merge it into the cpu_alloc branch. Its
pretty touchy work with some of the core components.


