Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYLWRgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYLWRgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYLWRg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:36:26 -0500
Received: from khc.piap.pl ([195.187.100.11]:35942 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYLWRgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:36:24 -0500
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?utf-8?B?SMOla29uIEzDuHZkYWw=?= <hlovdal@gmail.com>,
       Hannes Eder <hannes@hanneseder.net>, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/27] drivers/net: fix sparse warnings: make do-while a compound statement
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191507.11807.50794.stgit@vmbox.hanneseder.net>
	<m3hc4voo2a.fsf@maximus.localdomain>
	<a01a16b50812221544x45c3559ap808ac0095ee8f01@mail.gmail.com>
	<m3ocz2ua3w.fsf@maximus.localdomain> <1230053186.1447.9.camel@brick>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 23 Dec 2008 18:36:22 +0100
In-Reply-To: <1230053186.1447.9.camel@brick> (Harvey Harrison's message of "Tue\, 23 Dec 2008 09\:26\:26 -0800")
Message-ID: <m3k59qssix.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> writes:

>> There are many ways to make the code more merge friendly at a cost of
>> readability. Hope we don't go this way.
>
> Linus himself added that particular warning to sparse...may want to check
> with him the reason for it.

Once again, this is a personal thing, and a harmless one.

Sometimes I think using this sparse thing does more harm than good.
Not that the tool itself is bad - I find it really useful, many sparse
warnings actually did cause code improvement.

It's like with knives, there are good uses and a bit less good ones.
-- 
Krzysztof Halasa
