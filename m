Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYCHKZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYCHKZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 05:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYCHKZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 05:25:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYCHKZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 05:25:06 -0500
Message-ID: <47D26731.4000800@zytor.com>
Date: Sat, 08 Mar 2008 11:15:13 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: [PATCH] x86: remove pointless comments
References: <20080308.181506.04857887.xiyou.wangcong@gmail.com>
In-Reply-To: <20080308.181506.04857887.xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> Since arch/i386 directory is non-existed yet, those comments are
> pointless. Remove them all.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

One of the modules were by Antonino Daplas, who should be allowed to ACK 
it too.

	-hpa
