Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYE2GBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYE2GBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYE2GBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:01:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYE2GBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:01:47 -0400
Date: Wed, 28 May 2008 23:01:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Karpenko <alexander@comm.utoronto.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix fn key on Macbook Pro 4,1 and Macbook Air   (CC me
 on replies)
Message-Id: <20080528230137.c25b5e87.akpm@linux-foundation.org>
In-Reply-To: <3CF690CE-DD01-4EE4-8B40-E2641D5C06AB@comm.utoronto.ca>
References: <3CF690CE-DD01-4EE4-8B40-E2641D5C06AB@comm.utoronto.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 23:59:01 -0400 Alexander Karpenko <alexander@comm.utoronto.ca> wrote:

> Summary: The fn key does not work on Macbook Pro 4,1 and Air,  
> preventing the user from using the keyboard's media keys, volume keys,  
> PgUp, PgDn, Home, End, Delete, and adjusting screen brightness.
> 
> Keywords: macbook, fn key, keyboard, hid, quirks
> 
> Kernel version: 2.6.24-16-generic
> 
> I've posted the patch to this bug report, which outlines the problem,  
> debugging, and fix in more detail: https://bugs.launchpad.net/mactel-support/+bug/207127
> 
> The direct link to the patch is: http://launchpadlibrarian.net/14613817/fix_fn_key_on_macbookpro_4_1_and_mb_air.patch
> 
> Patch description:
> The patch adds the device IDs of the keyboards (ANSI, ISO, JIS for MB  
> Pro/Air) to drivers/hid/usbhid/hid-quirks.c.
> 
> Please CC me on replies, as I'm not subscribed to this mailing list.
> 

Please include the patch, all relevant descriptive matter and a
signed-off-by: all in the same email.

Documentation/SubmittingPatches goes into details.

Thanks.
