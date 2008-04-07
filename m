Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbYDGQiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbYDGQiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 12:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYDGQiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 12:38:04 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:43981 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYDGQiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 12:38:03 -0400
Message-ID: <47FA4DB0.6030804@panasas.com>
Date: Mon, 07 Apr 2008 19:37:04 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Adrian Bunk <bunk@kernel.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       apw@shadowen.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080406100826.GD30987@cs181133002.pp.htv.fi> <20080406110823.GA18058@uranus.ravnborg.org>
In-Reply-To: <20080406110823.GA18058@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 06, 2008, 14:08 +0300, Sam Ravnborg <sam@ravnborg.org> wrote:
>>>     This also relaxes the tab doctrine, because spaces DO make sense --
>>>     especially when you view the code with a tab setting of not-8.
>>> ...
>> In the kernel all tabs are 8 spaces wide.
>>
>> When you view the code with a different setting that's your fault.
> And for other kernel developers tabs are for indention, spaces for alignment.
> 
> Forget it - the world will not unify about this.

Resistance to change is only natural, but OTOH no change leads to stagnation.
I completely agree that if we don't encourage this as an alternative it will
indeed never happen but just saying "forget it" brings us nowhere.

I still believe that once people get used to this mentally they can see this
method's merits and how its logic relates to the program's structure: syntax
and coding style.

Benny

> 
> 	Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

