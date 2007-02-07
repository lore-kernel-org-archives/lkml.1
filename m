Return-Path: <linux-kernel-owner+w=401wt.eu-S1422819AbXBGXx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422819AbXBGXx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422814AbXBGXx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:53:26 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:50849 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422805AbXBGXxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:53:24 -0500
Date: Thu, 8 Feb 2007 00:49:43 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?6Kix5oGG5ZiJ?= <edward_hsu@realtek.com.tw>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
Message-ID: <20070207234943.GA4445@electric-eye.fr.zoreil.com>
References: <45C2F390.4070805@realtek.com.tw> <20070203003952.GA22823@electric-eye.fr.zoreil.com> <45C6A8EC.5090201@realtek.com.tw> <20070206003130.GA18236@electric-eye.fr.zoreil.com> <45C7EB8A.1090700@realtek.com.tw> <20070206213827.GA25119@electric-eye.fr.zoreil.com> <45C94693.5090900@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45C94693.5090900@realtek.com.tw>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

許恆嘉 <edward_hsu@realtek.com.tw> :
> Dear Francois:
> 
> I think I didn't make it clear about the programming manuals for PCI-E ICs.
> 
> Due to several legal issues, Realtek won't put the programming guide on 
> its website. However, Realtek does offer the programming guide if the 
> customers need it. If you want to have a copy of it, please contact 
> Realtek FAE<ryankao@realtek.com.tw>.

Does it mean that the documentation is NDAed ?

On an unrelated topic, revision 8.001.00 of your 8168 driver includes
a workaround for an rx fifo overflow issue. Is it an event which can
happen at any time, repeteadly if some rare conditions are met or is
it enough to whack the device once for all when the problem happens ?

-- 
Ueimor
