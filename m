Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYH2Xgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYH2Xgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYH2Xg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:36:26 -0400
Received: from smtp.ono.com ([62.42.230.12]:7474 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752449AbYH2XgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:36:25 -0400
Date: Sat, 30 Aug 2008 01:36:22 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Unhiding devices in pci bus
Message-ID: <20080830013622.4daecf8e@werewolf.home>
In-Reply-To: <alpine.BSF.1.00.0808292135320.32255@anduin.net>
References: <alpine.BSF.1.00.0808292135320.32255@anduin.net>
X-Mailer: Claws Mail 3.5.0cvs31 (GTK+ 2.13.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 21:43:32 +0200 (CEST), Erik Inge Bolsø <knan-lkml@anduin.net> wrote:

> You are doing the setpci magic trick, I assume?
> 
> if not, add 
> "setpci -d 197b:2381 AE=47"
> to your boot scripts.
> 
> (From the stock linpus boot scripts.)
> 

It has never worked for me.

But FYI, 2-6-27-rc5 boots fine with the card inserted and detects the
reader. No hack needed.
And ether and wifi both work.
But it has other problems.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
