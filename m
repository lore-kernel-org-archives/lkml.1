Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYFISEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYFISEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYFISEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:04:08 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:27888 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbYFISEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:04:07 -0400
Date: Mon, 9 Jun 2008 20:06:41 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Julia Lawall <julia@diku.dk>
Cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 3/4] drivers/video/fsl-diu-fb.c: add
 missing of_node_put
Message-Id: <20080609200641.9544b500.krzysztof.h1@poczta.fm>
In-Reply-To: <Pine.LNX.4.64.0806091420450.16009@ask.diku.dk>
References: <Pine.LNX.4.64.0806091420450.16009@ask.diku.dk>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 3ce2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 14:21:18 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> of_node_put is needed before discarding a value received from
> of_find_node_by_type, eg in error handling code.
> 
(...)
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---------------------------------------------------------------
Sprawdz jak zdobyc zdrowy usmiech!
Kliknij >> http://link.interia.pl/f1e26

