Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbYHQSkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYHQSkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYHQSkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:40:36 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:1907 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYHQSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:40:35 -0400
Date: Sun, 17 Aug 2008 20:46:23 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Bryan Wu <cooloney@kernel.org>
Cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/1] Video/Framebuffer: add
 fuctional power management support to Blackfin BF54x LQ043 framebuffer
 driver
Message-Id: <20080817204623.47fd24a1.krzysztof.h1@poczta.fm>
In-Reply-To: <1218791228-12974-1-git-send-email-cooloney@kernel.org>
References: <1218791228-12974-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: f2e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 17:07:08 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Fix bug: does nor properply resume after suspend mem
> Fix for PM_SUSPEND_MEM: Save and restore peripheral base and DMA registers
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/video/bf54x-lq043fb.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

----------------------------------------------------------------------
Igrzyska z nagrodami! Kliknij>>>> http://link.interia.pl/f1edb 

 	

