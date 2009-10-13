Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZJMMUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZJMMUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759615AbZJMMUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:20:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42055 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbZJMMUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:20:23 -0400
Message-ID: <4AD4705D.6020109@openvz.org>
Date: Tue, 13 Oct 2009 16:19:41 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>, vatsa@in.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com> <4AD466E5.4010206@openvz.org> <20091013120354.GF24787@MAIL.13thfloor.at>
In-Reply-To: <20091013120354.GF24787@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> as I already stated, it seems perfectly fine for me 

You're not the only one interested in it, sorry. Besides, I
got your point in "I'm find with it". Now get mine which is
about "I am not".

> can be trivially mapped to the two values, by chosing a
> fixed multiplicative base (let's say '1s' to simplify :) 
> 
>   with 50%, you get 1s/0.5s
>   with 20%, you get 1s/0.2s
>   with  5%, you get 1s/0.05s
> 
> well, you get the idea :)

No I don't.
Is 1s/0.5s worse or better than 2s/1s?
How should I make a choice?
