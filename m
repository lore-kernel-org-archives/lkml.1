Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYG3BOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYG3BOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYG3BOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:14:10 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:20738 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074AbYG3BOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:14:09 -0400
Date: Wed, 30 Jul 2008 10:13:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       linux-sh@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] kdump: sh: parse elfcorehdr command line argument
Message-ID: <20080730011325.GA7529@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-sh@vger.kernel.org,
	Vivek Goyal <vgoyal@redhat.com>
References: <20080730002937.GA21998@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730002937.GA21998@verge.net.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 10:29:39AM +1000, Simon Horman wrote:
> A quick cut and paste from other architectures to allow SH
> to parse the elfcorehdr command line argument which is required
> for both is_kdump_kernel() and vmcore to function.
> (the former is as yet unused on SH).
> 
> Tested compilation only
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
This was the first thing I was going to do this morning, but you beat me
to it. :-)

Applied, thanks!
