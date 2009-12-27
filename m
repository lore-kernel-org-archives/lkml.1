Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbZL0Vgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbZL0Vgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZL0Vgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:36:47 -0500
Received: from www84.your-server.de ([213.133.104.84]:39982 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZL0Vgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:36:46 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <200912271003.631128760@firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 22:36:40 +0100
Message-ID: <1261949800.25298.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> While porting some of my code to kfifo I found some issues, which
> are addressed in the following patch series.
> 
> Some of the problems were serious, particularly the non atomic kfifo_in()
> problem. That's probably 2.6.33 material at least. 
> 

I am not happy to see you to take over my project. Especial as most of
your fixes are part of my new macro based implementation. Have a look at
http://patchwork.kernel.org/patch/69093/

Stefani


