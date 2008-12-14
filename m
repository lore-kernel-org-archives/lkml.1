Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYLNWah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYLNWah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYLNWaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:30:01 -0500
Received: from smtp2.ono.com ([62.42.230.20]:9900 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753662AbYLNWaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:30:00 -0500
Date: Sun, 14 Dec 2008 23:29:33 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
Message-ID: <20081214232933.5dcf5331@werewolf.home>
In-Reply-To: <1229174138.24940.9.camel@maxim-laptop>
References: <491506DB.1070000@gmail.com>
	<1229174138.24940.9.camel@maxim-laptop>
X-Mailer: Claws Mail 3.6.1cvs75 (GTK+ 2.14.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 15:15:38 +0200, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> 
> So, big thanks for everything.
> 
> Now aspire one linux support is very close to perfect,
> (only problem left is that wireless is limited to 18Mbits/s raw rate,
> but at some point I or developers of ath5k will get to the bottom of
> this)
> 

I have seen ine gone to 24 and 36 Mb/s, doing a copy in gnome GUI via
sftp (at a couple feet from the router ;).

But at some point, the copy blocked and dmesg said:

ath5k phy0: unsupported jumbo
ath5k phy0: unsupported jumbo

Apart from that, and the led problem, wifi works pretty fine.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
