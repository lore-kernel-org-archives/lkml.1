Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYKRRTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYKRRTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbYKRRSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:18:20 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43824 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYKRRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:18:16 -0500
Message-ID: <4922F8C4.80509@nortel.com>
Date: Tue, 18 Nov 2008 11:17:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fredrik_Markstr=F6m?= 
	<fredrik.markstrom@avalonenterprise.com>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>	 <4922ED5A.3030808@shaw.ca> <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
In-Reply-To: <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Nov 2008 17:17:59.0958 (UTC) FILETIME=[9B39AB60:01C949A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrik Markström wrote:

> At this point I feel that we have two possibilities, help our customer
> violate GPL or say no to the project. I'd prefer a third option where
> I could tell the customer that we can setup the project in a certain
> way (some "cleanroom" setup ?) to ensure that the results can not be
> considered derived work.
> 
> Is your short answer also the definite answer considering this ?

I'm not a lawyer, and you need to consult one.

There isn't really a "definate answer" since it depends on copyright 
law, which varies by region.  The key question is whether the driver is 
a derivative work of the kernel under copyright law.  For the purposes 
of copyright law this is primarily a legal question, not a technical one.

There are some that claim that a driver written for another OS and 
running in linux via a shim layer could qualify (especially if the 
closed-source portion is written without any knowledge of linux 
internals).  Nvidia is one company that does this, but there are others 
as well.

Also, releasing the driver under the GPL doesn't necessarily mean 
"released to the world".  Technically, they would only need to provide 
source code to their customers.  Of course, their customers would be 
free to redistribute, but it's unlikely that most of them would bother.

Chris
