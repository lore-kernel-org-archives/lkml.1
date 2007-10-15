Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbXJOOCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbXJOOCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765277AbXJOOCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:02:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765266AbXJOOCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:02:31 -0400
Date: Mon, 15 Oct 2007 07:01:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Anton Blanchard <anton@samba.org>
Cc: rt2400-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
 rt2x00
Message-ID: <20071015070154.4002340f@laptopd505.fenrus.org>
In-Reply-To: <20071015054034.GC3257@kryten>
References: <20071015053428.GA3257@kryten>
	<20071015053801.GB3257@kryten>
	<20071015054034.GC3257@kryten>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 00:40:34 -0500
Anton Blanchard <anton@samba.org> wrote:

> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
