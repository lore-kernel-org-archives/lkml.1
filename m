Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbXFQL0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbXFQL0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbXFQL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:26:39 -0400
Received: from smtp.nokia.com ([131.228.20.171]:43093 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbXFQL0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:26:39 -0400
Subject: Re: [PATCH] fix memory leak in UBI scanning unit
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490706121521q1192b9dbp6b2adff087fc01d@mail.gmail.com>
References: <200705100026.12639.jesper.juhl@gmail.com>
	 <1178784573.3734.5.camel@sauron>
	 <9a8748490706121521q1192b9dbp6b2adff087fc01d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 17 Jun 2007 14:26:33 +0300
Message-Id: <1182079593.4403.15.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Jun 2007 11:26:33.0341 (UTC) FILETIME=[5BD142D0:01C7B0D2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 00:21 +0200, Jesper Juhl wrote:
> Any idea when you'll be merging with Linus?
> I just checked mainline git and the bug is still there :-(

This bug is in debugging code and is nearly impossible to hit,
so it will be merged during the next merge window.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

