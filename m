Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYGQTqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYGQTqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbYGQTpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:45:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58683 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713AbYGQTps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:45:48 -0400
Message-ID: <487FA164.9040306@garzik.org>
Date: Thu, 17 Jul 2008 15:45:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [patch 02/29] ariadne: use netstats in net_device structure
References: <20080717191607.955742542@mail.of.borg> <20080717191749.977933994@mail.of.borg>
In-Reply-To: <20080717191749.977933994@mail.of.borg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 
> Use net_device_stats from net_device structure instead of local.
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


