Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYFBFkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYFBFkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYFBFkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:40:46 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:59698
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbYFBFkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:40:45 -0400
MIME-Version: 1.0
Date: Mon, 2 Jun 2008 07:22:44 +0200
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
In-Reply-To: <48435CCA.5000905@gmail.com>
References: <48435CCA.5000905@gmail.com>
Message-ID: <f513a98ea2e03f81941beae941a63b42@localhost>
User-Agent: RoundCube Webmail/0.1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 01 Jun 2008 21:36:58 -0500, Roger Heflin <rogerheflin@gmail.com>
wrote:
> Arjan van de Ven wrote:
>>
>> just as a side note.. you do realize that with p4-clockmod, your cpu is
>> still running at 1.7 GHz right? (it's just doing less work '-)
>  From my testing, I believe the only thing that p4-clockmod does is
forces
> an
> idle call when it could otherwise do work on an active process, so
> fullspeed and
> idle uses *EXACTLY* the same amount of power as p4-clockmod slower speed
<snip>

Thanks for the detailed information everyone. The first time I tested this
I was under the impression that it indeed had an influence on the produced
heat of the CPU. I did a quick test this morning and of course you are
right, there is no change at all. 

This is a good thing though, since it gives me an excuse to upgrade this
machine to a C2D. :)
For the time being I will just disable the cpufreq stuff since it really
does not make a difference in my case.

Kind regards,
Michael

