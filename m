Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbXGQBj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbXGQBj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbXGQBjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:39:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbXGQBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:39:20 -0400
Message-ID: <469C1DC3.6030000@zytor.com>
Date: Mon, 16 Jul 2007 18:39:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] zisofs use mutex instead of semaphore
References: <20070717085451.GA4179@darkstar.te-china.tietoenator.com>
In-Reply-To: <20070717085451.GA4179@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> Hi,
> 
> Use mutex instead of semaphore in fs/isofs/compress.c, and remove a
> unnecessary variable.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Acked-by: H. Peter Anvin <hpa@zytor.com>
