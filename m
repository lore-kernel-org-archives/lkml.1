Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYFBQyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYFBQyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYFBQy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:54:26 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:39169 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYFBQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:54:25 -0400
Date: Mon, 2 Jun 2008 18:56:37 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Frans Pop <elendil@planet.nl>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [VIDEO] vfb: only enable if explicitly
 requested when compiled in
Message-Id: <20080602185637.bb1dedfb.krzysztof.h1@poczta.fm>
In-Reply-To: <200806011454.23123.elendil@planet.nl>
References: <200806011454.23123.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: f8e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 14:54:22 +0200
Frans Pop <elendil@planet.nl> wrote:

> From: Frans Pop <elendil@planet.nl>
> 
> The Kconfig help for the vfb driver says:
>    Do NOT enable it for normal systems! To protect the innocent, it
>    has to be enabled explicitly at boot time using the kernel option
>    `video=vfb:'.
>     
> This change lets the code match the description.
>     
> Support for vfb:disable is kept for backwards compatibility; vfb:off
> works because it is tested at a higher level.
>     
> Signed-off-by: Frans Pop <elendil@planet.nl>
> CC: Antonino A. Daplas <adaplas@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> 
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


----------------------------------------------------------------------
Podbij Dziki Zachod!Gra strategiczna online
Sprawdz >>> http://link.interia.pl/f1dff

