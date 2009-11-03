Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZKCToI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZKCToI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZKCToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:44:07 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:41259 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZKCToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:44:04 -0500
Message-ID: <4AF08292.7090102@codefidence.com>
Date: Tue, 03 Nov 2009 21:20:50 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Ori Finkelman <ori@comsleep.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
References: <5765.1257270611@turing-police.cc.vt.edu> <4AF07024.80103@gmail.com>
In-Reply-To: <4AF07024.80103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> Valdis.Kletnieks@vt.edu a écrit :
>   
>> Seen right after I started 'fetchmail'.  Reproducible - 3 out of 3.
>> I'll bisect this tonight if nobody jumps up and yells they know what it is...
>>     
Bah... this is most probably my fault. Sorry about that.

Can you please try the patch in the next email?

But also, can you please send me the route table in effect when this 
happened and the fetchmail command line/config (removing any passwords 
or account details of course)? I want to understand better when this 
happens.

Thanks!
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker & CTO
Codefidence Ltd.

Web:   http://codefidence.com
Cell:  +972-52-8260388
Skype: gilad_codefidence
Tel:   +972-8-9316883 ext. 201
Fax:   +972-8-9316884
Email: gilad@codefidence.com

Check out our Open Source technology and training blog - http://tuxology.net

	"The biggest risk you can take it is to take no risk."
		-- Mark Zuckerberg and probably others

