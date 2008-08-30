Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYH3VOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYH3VOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYH3VOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:14:06 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:56665 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYH3VOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:14:05 -0400
Message-ID: <48B9B81A.3070306@mandriva.org>
Date: Sun, 31 Aug 2008 00:14:02 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080808)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
References: <48B94120.1010108@mandriva.org>
In-Reply-To: <48B94120.1010108@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund skrev:
> Hi, (please cc me as I'm not subscribed)
> 
> thought I would post this right now, I'll try to reproduce it with 
> vanilla 2.6.27-rc5 as soon as the buildhost is back up...
> 

Nevermind this "BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 
61s!." part ...

It was caused by a Tomoyo patch that was not correct...

I just assumed it was the same as the laptop locked up too...

> (vanilla 2.6.27-rc5 x86_64 also locked up my laptop wich is a
>  Core2 Duo T8300 during kernel build with make -j3, but
>  I dont have any logs of that yet)
> 

This issue is still a real one, but I need to get some oops on it...

I'll report back when I know more

--
Thomas
