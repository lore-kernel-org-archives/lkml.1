Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYJZPC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYJZPC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYJZPCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:02:17 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:47209 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbYJZPCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:02:16 -0400
Date: Sun, 26 Oct 2008 16:01:42 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>
Subject: Re: r8169 MAC addresses broken
Message-ID: <20081026150142.GA24790@electric-eye.fr.zoreil.com>
References: <490380C8.6070003@simon.arlott.org.uk> <4903947A.3060206@gmail.com> <20081025223443.GA30913@electric-eye.fr.zoreil.com> <490448B0.8050307@gmail.com> <m33aijzfga.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m33aijzfga.fsf@maximus.localdomain>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> :
[...]
> First the ICH* e1000e corruption and now GbE RTL.

Ok, consider the whole thing reverted.

I thought this code could be made to work for -rc1 but new
failures keep appearing. Sorry for the mess.

-- 
Ueimor
