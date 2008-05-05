Return-Path: <linux-kernel-owner+w=401wt.eu-S1765449AbYEESsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765449AbYEESsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760981AbYEESkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:40:31 -0400
Received: from www.tglx.de ([62.245.132.106]:41410 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763162AbYEESk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:40:29 -0400
Message-ID: <481F5520.2050103@linutronix.de>
Date: Mon, 05 May 2008 20:42:40 +0200
From: Sebastian Siewior <bigeasy@linutronix.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] usb/host/isp1760-hcd.c: make 2 functions static
References: <20080505182533.GQ17139@cs181133002.pp.htv.fi>
In-Reply-To: <20080505182533.GQ17139@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - enqueue_an_ATL_packet()
> - enqueue_an_INT_packet()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Thank you Adrian.
