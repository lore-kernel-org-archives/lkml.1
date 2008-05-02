Return-Path: <linux-kernel-owner+w=401wt.eu-S937007AbYEBVSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937007AbYEBVSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764904AbYEBVSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:18:24 -0400
Received: from gw.goop.org ([64.81.55.164]:47364 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759125AbYEBVSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:18:24 -0400
Message-ID: <481B851D.90905@goop.org>
Date: Fri, 02 May 2008 14:18:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Frans Pop <elendil@planet.nl>, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hfsplus: Correct user visible printk
References: <20080502142925.2e439d8a@core>	<200805021600.42610.elendil@planet.nl>	<20080502150439.76beaf27@core>	<200805021742.50509.elendil@planet.nl> <20080502164414.63615eb5@core>
In-Reply-To: <20080502164414.63615eb5@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Finally I put more weight on the views of the professional bodies for
> computing than on you ;)
>   

Prescriptive arguments from authority don't really carry much weight.  
In this case it's particularly weak since Apple refer to hfs as a 
"journaled" or "journaling" filesystem[1].

And now I've been staring at it for so long that its just turned into a 
weird word...

    J

[1] http://docs.info.apple.com/article.html?artnum=107249
