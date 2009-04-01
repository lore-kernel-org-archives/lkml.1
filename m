Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbZDASEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbZDASEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbZDASEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:04:37 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:9054 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbZDASEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:04:36 -0400
Date: Wed, 1 Apr 2009 19:05:50 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, thomas@winischhofer.net,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] sisfb: fix color component length
 for pseudocolor modes
Message-Id: <20090401190550.fe7b98c7.krzysztof.h1@poczta.fm>
In-Reply-To: <20090330221340.GF6993@spock.one.pl>
References: <20090330221340.GF6993@spock.one.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: a6e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 00:13:40 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> sisfb incorrectly sets the length of the color fields to 6 bits
> for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
> Fix this by setting the length to 8.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> Cc: Thomas Winischhofer <thomas@winischhofer.net>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


----------------------------------------------------------------------
Twoj znajomy gwiazda filmu XXX? Wkrec go! ;) 
Kliknij >>> http://link.interia.pl/f20f1

