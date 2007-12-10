Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbXLJPjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbXLJPjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXLJPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:39:06 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:13074 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbXLJPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:39:05 -0500
Message-ID: <475D5D53.8070906@netone.net.tr>
Date: Mon, 10 Dec 2007 17:37:55 +0200
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jerry Geis <geisj@pagestation.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG in 2.6.23.9
References: <475C46BC.5020101@pagestation.com>	<20071209134418.14c9f09d@laptopd505.fenrus.org>	<475D0387.1070609@netone.net.tr> <20071210064524.50d5b709@laptopd505.fenrus.org>
In-Reply-To: <20071210064524.50d5b709@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2007 15:37:28.0713 (UTC) FILETIME=[9238B790:01C83B42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> well... try to get the oops message out; for many causes of crash that's a good way to find out what happened...
> (not always, but it allows us to find patterns if nothing else)
>
>   
Unfortunately, I couldn't get the oops message. Because when this 
behavior happens, the machine hardly freezes and the SysRq combinations 
do not work. Also, I checked the logs (message,syslog,kern.log etc.) to 
see something suspicious. Unfortunately, there was none. Just one thing 
I noticed  when investigating on the logs: the kernel is doing its 
regular jobs. Like cron etc. So, the kernel is not really dieing. Next 
time, I will try to ssh to my machine to check what's going on, when 
this behavior occurred.
