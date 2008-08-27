Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYH0Er6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYH0Er6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 00:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbYH0Eru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 00:47:50 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:25723 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYH0Eru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 00:47:50 -0400
Date: Wed, 27 Aug 2008 06:54:10 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: <JosephChan@via.com.tw>
Cc: <linux-kernel@vger.kernel.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [Linux-fbdev-devel] [PATCH 11/13 v3] viafb: viafbdev.c
Message-Id: <20080827065410.d40b28a2.krzysztof.h1@poczta.fm>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB807A42C06@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB807A42C06@exchtp03.taipei.via.com.tw>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 54e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 17:51:47 +0800
<JosephChan@via.com.tw> wrote:

> Remove the marco MMIO_OUT32, and replace it with writel() function.
> And replace "u32" with "unsigned long" in writel() function (original 
> MMIO_OUT32 marco) for avoiding warning message in 64bit OS.
> 
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

----------------------------------------------------------------------
Tylko u nas - swieza krew w rozsadnych cenach!
>> http://link.interia.pl/f1eed

