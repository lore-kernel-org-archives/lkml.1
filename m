Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZLIPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZLIPnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZLIPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:43:41 -0500
Received: from mx.sz.bfs.de ([194.94.69.70]:46385 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZLIPnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:43:40 -0500
Message-ID: <4B1FC5A4.9030300@bfs.de>
Date: Wed, 09 Dec 2009 16:43:32 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jan Yenya Kasprzak <kas@fi.muni.cz>
Cc: Rudy Matela <rudy.matela@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       trivial@kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coding style correction on some drivers that use Generic
 HDLC
References: <20091209143540.GA9620@vacuum.larces.uece.br> <20091209145554.GQ6070@fi.muni.cz>
In-Reply-To: <20091209145554.GQ6070@fi.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jan Yenya Kasprzak schrieb:
> Rudy Matela wrote:
> : Added a space separating some if/switch/while keywords from the following
> : parenthesis to conform to the CodingStyle.
> 
> 	Hello,
> 
> 	I am not sure whether it is necessary to fix formating mistakes in
> a driver which is in deep freeze and the hardware is not produced anymore,
> but whatever.
> 
> Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
> 
> -Yenya
> 
> : Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
> : ---
> : 
> :  drivers/net/wan/cosa.c       |   10 +++++-----
> :  drivers/net/wan/hdlc_cisco.c |    8 ++++----
> :  drivers/net/wan/hdlc_x25.c   |    4 ++--
> :  3 files changed, 11 insertions(+), 11 deletions(-)
> : 
> : diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
> : index b36bf96..f0bd70f 100644
> 

It is ok until the driver is removed, if this "issue" is not fixed it will
trigger any check-coding-style and generate new patches. Since it involves
no code changes it is harmless.

re,
 wh

