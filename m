Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYIBREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYIBREw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYIBREk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:04:40 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11914 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYIBREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:04:39 -0400
Message-ID: <48BD721E.4060401@hp.com>
Date: Tue, 02 Sep 2008 10:04:30 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Valdis.Kletnieks@vt.edu, jmalicki@metacarta.com, andi@firstfloor.org,
       johnpol@2ka.mipt.ru, dada1@cosmosbay.com, denys@visp.net.lb,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <21915755.1327801219904892242.JavaMail.root@ouachita>	<48B6E7D0.5070307@hp.com>	<20031.1220236756@turing-police.cc.vt.edu> <20080831.205145.225080276.davem@davemloft.net>
In-Reply-To: <20080831.205145.225080276.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think anyone in this thread can even pretend to understand how
> any of this stuff works

So so last week I started asking FSI contacts I've built-up while 
answering their "how to improve latency" questions.  The intent is to 
get some direct input from them on just what their and their regulator's 
expecations are wrt timestamping of packets and/or trades.

rick jones
