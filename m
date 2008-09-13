Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYIMAl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYIMAl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYIMAlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:41:16 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61902 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756671AbYIMAlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:41:16 -0400
Date: Sat, 13 Sep 2008 01:40:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: io-apic - do not use KERN_DEBUG marker too much
In-Reply-To: <20080912201848.GB8410@lenovo>
Message-ID: <Pine.LNX.4.55.0809122316410.23962@cliff.in.clinika.pl>
References: <20080908153806.GB7278@lenovo> <86802c440809121255k1af2881dwb00ebb6f4a58057b@mail.gmail.com>
 <86802c440809121257s23e5193aqb7939fdc94473c9d@mail.gmail.com>
 <20080912201848.GB8410@lenovo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008, Cyrill Gorcunov wrote:

>  but quite frankly - it reveals another problem -
>  printing between other printing - which means
>  ideally it would be to _have_ temporary buffer apart
>  from printk buffer. So we have - either adding additional

 Exactly what I wrote!

  Maciej
