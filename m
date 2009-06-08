Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZFHGkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZFHGkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZFHGkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:40:13 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33273 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZFHGkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:40:12 -0400
Message-ID: <4A2CB244.2050701@cosmosbay.com>
Date: Mon, 08 Jun 2009 08:40:04 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: eko suwarsono <ekoswr76@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux Bridge Module
References: <6d6e77f50906072256m31c17ae8j5c4634ab5ad44761@mail.gmail.com>
In-Reply-To: <6d6e77f50906072256m31c17ae8j5c4634ab5ad44761@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 08 Jun 2009 08:40:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eko suwarsono a écrit :
> Hi all
> 
> I'm newbies on this mailing list, so please advise me if i asking the
> wrong question.
> I had plan to add bridge module (bridge.ko) on embedded system which i
> got from vendor. the embedded linux system is using Debian sarge 1.3
> and has linux kernel 2.6.20.4 with gcc 3.4.4. the operating system is
> installed on CF card
> 
> i tried to compile the linux kernel 2.6.20.4 using gcc 3.4.4 on
> another system which using ubuntu feisty to get the bridge.ko module.
> and then copying the module into the embedded system.
> 
> the problem here that the insmod complaining : -1 invalid module format.
> 
> can somebody help me on this? many thanks for all

Take a look at dmesg output

Also, has your embedded system provided a /boot/config-2.6.20.4 file ?
If not, it will be difficult to match all configuration settings...

