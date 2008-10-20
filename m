Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYJTUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYJTUNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYJTUNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:13:14 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:33948 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123AbYJTUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:13:13 -0400
Date: Mon, 20 Oct 2008 22:13:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.2: NETDEV WATCHDOG: eth0 (r8169): transmit timed out
Message-ID: <20081020201306.GA19486@electric-eye.fr.zoreil.com>
References: <200810201251.51836.assirati@nonada.if.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810201251.51836.assirati@nonada.if.usp.br>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joao Luis Meloni Assirati <assirati@nonada.if.usp.br> :
[...]
> I am having some kernel messages in my Acer Aspire One under Linux 2.6.27.2, 
> followed by network-manager crashes. Below are the messages and my kernel 
> config.
> 
> Please, CC me as I am not subscribed to the list.

I am not completely sure but it could be that your laptop includes
a kind of 8102 ethernet chipset which needs a post 2.6.27 kernel.

Can you try current 2.6.27 git kernel + the patches at:

http://userweb.kernel.org/~romieu/r8169/2.6.27-git8/20081020

A dmesg of the patched kernel will be welcome.

-- 
Ueimor
