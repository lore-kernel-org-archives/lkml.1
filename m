Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbXJXUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbXJXUha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbXJXUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:37:22 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:41866 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbXJXUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:37:21 -0400
Message-ID: <471FACB9.4050502@free.fr>
Date: Wed, 24 Oct 2007 22:36:09 +0200
From: Thierry Merle <thierry.merle@free.fr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] usbvision: Convert semaphore to
 mutex
References: <20071024143621.GD9824@traven>
In-Reply-To: <20071024143621.GD9824@traven>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Matthias Kaehlcke a écrit :
> usbvision: Convert the usbvision->lock semaphore to the mutex API
>
>   
I adapted your patch to the v4l-dvb hg tree
(http://linuxtv.org/hg/~tmerle/v4l-dvb) thanks.

Thierry
