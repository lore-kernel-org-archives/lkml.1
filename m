Return-Path: <linux-kernel-owner+w=401wt.eu-S936049AbYEBSwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936049AbYEBSwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764041AbYEBSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:51:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763987AbYEBSvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:51:53 -0400
Message-ID: <481B62B1.5040705@zytor.com>
Date: Fri, 02 May 2008 11:51:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH] x86: fix up bootparam.h for userspace inclusion
References: <200805022114.20672.rusty@rustcorp.com.au>
In-Reply-To: <200805022114.20672.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> commit 8b664aa66e824a0ddf4ec56d41fa0cf7bb374de6 (x86, boot: add linked
> list of struct setup_data) put a new struct in bootparam.h, but didn't
> use the userspace-safe types.
> 
> CC: Huang, Ying <ying.huang@intel.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
