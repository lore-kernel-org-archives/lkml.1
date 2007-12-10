Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXLJJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXLJJ1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXLJJ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:27:05 -0500
Received: from denise.shiny.it ([194.20.232.1]:34423 "EHLO denise.shiny.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXLJJ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:27:04 -0500
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2007 04:27:03 EST
Date: Mon, 10 Dec 2007 10:06:51 +0100 (CET)
From: Giuliano Pochini <pochini@denise.shiny.it>
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] echoaudio semaphore to mutex
In-Reply-To: <20071209171601.368743645@gmail.com>
Message-ID: <Pine.LNX.4.64.0712100922250.20059@denise.shiny.it>
References: <20071209171509.601451827@gmail.com> <20071209171601.368743645@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Dec 2007, Kevin Winchester wrote:

> Convert the semaphore to a mutex in echoaudio.c
>
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

It's an 1:1 change. It looks fine to me.

Acked-by: Giuliano Pochini <pochini@shiny.it>


--
Giuliano.
