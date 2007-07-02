Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbXGBRC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbXGBRC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 13:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXGBRCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 13:02:20 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2561 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXGBRCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 13:02:16 -0400
Message-ID: <46892F97.9060400@domdv.de>
Date: Mon, 02 Jul 2007 19:02:15 +0200
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org
Subject: Re: mss to pmtu clamping partially broken?
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net> <4684F5D3.8020506@domdv.de> <4684F75E.90304@trash.net>
In-Reply-To: <4684F75E.90304@trash.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Its possible that one of your ISPs is doing clamping. You could
> check on ppp0 if thats the case. Or maybe for some reason the
> PMTU value for the internal host is smaller than 1500. You can
> check that by doing "ip route get <internal host>".
> 
> 

Oh well, thew fun with ISPs. Same provider, clamping on one line but not
the other. This is fun :-(

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
