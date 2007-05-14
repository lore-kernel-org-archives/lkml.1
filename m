Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXENLZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXENLZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXENLZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:25:22 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:38732 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756022AbXENLZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:25:21 -0400
Message-ID: <46484716.9080802@tobbe.nu>
Date: Mon, 14 May 2007 13:25:10 +0200
From: Tobias Bengtsson <tobbe@tobbe.nu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: SDHCI issues on Ricoh in 2.6.20, 21 and 21-rc7-mm2
References: <4639D927.4080406@tobbe.nu> <4646EE93.8090307@drzeus.cx> <464776C0.5020007@overt.org>
In-Reply-To: <464776C0.5020007@overt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philip,

Philip Langdale wrote:
> Pierre has asked me to take a look implementing this. My first question is whether
> all card events are getting dropped on the floor, or just insertion ones. That is
> to say, if you have the card inserted when you load the module (which you say
> makes the card usable), does it correctly detect that the card is ejected when
> you eject it?
>   
Yes, the first time.
Reloading modules with card inserted again, and then remove it does not 
give me anything.

Thanks for your swift response!

regards, Tobias
