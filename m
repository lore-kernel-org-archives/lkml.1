Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYLYUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYLYUrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLYUrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:47:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYLYUrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:47:46 -0500
Message-ID: <4953F14A.8000801@zytor.com>
Date: Thu, 25 Dec 2008 12:47:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: remove impossible test in mtrr/main.c
References: <200812251718.44233.rusty@rustcorp.com.au>
In-Reply-To: <200812251718.44233.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Impact: cleanup
> 
> enable_mtrr_cleanup is static, and is never set to anything but 0 or 1.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Applied to tip:x86/pat2, thanks!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

