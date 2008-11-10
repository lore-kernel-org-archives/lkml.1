Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYKJFPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYKJFPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYKJFPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:15:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYKJFPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:15:38 -0500
Message-ID: <4917C350.5080808@zytor.com>
Date: Sun, 09 Nov 2008 21:14:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: w@1wt.eu
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.37-rc2
References: <20081109234747.GA15813@hera.kernel.org>
In-Reply-To: <20081109234747.GA15813@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> 
> The patch and changelog will appear soon at the following locations:
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37-rc2.bz2
>   ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37.log
> 

You probably want to drop the .all. infix here; it gives you round-robin
across all the kernel.org servers, instead of using geodns to get to the
closest one.

	-hpa
