Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYE3WO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYE3WO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYE3WOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:14:46 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7369 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYE3WOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:14:45 -0400
Message-ID: <48407C51.7090405@hp.com>
Date: Fri, 30 May 2008 15:14:41 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Cammarata <jimi@sngx.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -	e1000/pcnet32
References: <482DA5B6.1020606@sngx.net> <482DB46A.8020103@cosmosbay.com>	<482EF192.4070707@sngx.net> <482F5113.5090703@cosmosbay.com>	<482F610D.2080108@sngx.net> <20080518003104.GK28241@solarflare.com>	<482FBA09.80201@sngx.net> <483E0AAE.2020107@sngx.net>	<20080528221118.63da4092.akpm@linux-foundation.org>	<483EA2D1.8050603@sngx.net> <20080529154525.3916c7b5@core> <20080530151250.b44a119a.billfink@mindspring.com>
In-Reply-To: <20080530151250.b44a119a.billfink@mindspring.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Saving stats output and running beforeafter on a number of systems is
> a royal pain when troubleshooting.

Well, with that ringing endorsement :) I would like to state that 
Yoshihiro Ishijima has fixed some bugs in beforeafter and it will now 
deal with /proc/interrupts output better than before.

ftp://ftp.cup.hp.com/dist/networking/tools/

rick jones
