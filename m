Return-Path: <linux-kernel-owner+w=401wt.eu-S2992956AbXCIEhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992956AbXCIEhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 23:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992955AbXCIEhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 23:37:32 -0500
Received: from mail.tmr.com ([64.65.253.246]:33444 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992954AbXCIEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 23:37:30 -0500
Message-ID: <45F0E51F.9050105@tmr.com>
Date: Thu, 08 Mar 2007 23:39:59 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: albcamus <albcamus@gmail.com>
CC: Mockern@yandex.ru, linux-kernel@vger.kernel.org
Subject: Re: Question: schedule()
References: <45ED23E3.000004.17474@webmail18.yandex.ru> <df9815e70703060113w8eeeae3g6fc9ce6190eb380c@mail.gmail.com>
In-Reply-To: <df9815e70703060113w8eeeae3g6fc9ce6190eb380c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

albcamus wrote:
> your kthread IS preemptible unless you call preempt_disable or some
> locking functions explicitly .
> 
I think he's trying to go the other way, make his thread the highest 
priority to blow anything else in the system out of the water. See his 
previous post "how to make kernel thread more faster?"

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
