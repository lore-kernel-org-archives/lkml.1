Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbYDDHVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbYDDHVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYDDHU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:20:58 -0400
Received: from oss.sgi.com ([192.48.170.157]:53611 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYDDHU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:20:56 -0400
Date: Fri, 4 Apr 2008 08:20:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [MIPS] unexport null_perf_irq() and make it static
Message-ID: <20080404072048.GF12086@linux-mips.org>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com> <1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207094318-21748-6-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:58:38AM +0400, Dmitri Vorobiev wrote:

> This patch unexports the null_perf_irq() symbol, and simultaneously
> makes this function static.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

Queued for 2.6.26 with your static fix folded in.  Thanks,

  Ralf
