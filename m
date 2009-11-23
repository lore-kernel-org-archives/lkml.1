Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZKWTj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZKWTj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZKWTjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:39:24 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:27070 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZKWTjX convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;2:1>);
	Mon, 23 Nov 2009 14:39:23 -0500
Message-Id: <4B0A9E9E0200005A000597A2@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 23 Nov 2009 12:39:26 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Jaswinder Singh Rajput" <jaswinder@kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioq: includecheck fix
References: <1258825975.5364.16.camel@ht.satnam>
In-Reply-To: <1258825975.5364.16.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11/21/2009 at 12:52 PM, in message <1258825975.5364.16.camel@ht.satnam>,
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote: 

> fix the following 'make includecheck' warning:
> 
>   include/linux/ioq.h: linux/shm_signal.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Gregory Haskins <ghaskins@novell.com>

Applied, thanks!.

Kind Regards,
-Greg

