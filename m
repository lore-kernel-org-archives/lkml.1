Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXFXUoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXFXUoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXFXUoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:44:00 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37254
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXFXUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:43:59 -0400
Date: Sun, 24 Jun 2007 13:44:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Kyle Moffett <mrmacman_g4@mac.com>, djones@rossove.com,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: Scaling Max IP address limitation
In-Reply-To: <Pine.LNX.4.64.0706242153240.11964@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706241342340.12806@asgard.lang.hm>
References: <467EA7C1.4080006@rossove.com> <D6003DDE-0C36-437B-B70A-D422DFE153D0@mac.com>
 <Pine.LNX.4.64.0706242153240.11964@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Jan Engelhardt wrote:

>
> On Jun 24 2007 15:08, Kyle Moffett wrote:
>>
>> Do you really need that many IP addresses?  When somebody finally gets
>> around to implementing REDIRECT support for ip6tables then you could
>> just redirect them all to the same port on the local system.
>
> The way I see it, it's: "if someone gets around to implement *IPv6 NAT*"
> (which, if its designers were asked, is contrary to the idea of ipv6).

true, but back in the real world it's sometimes desriable to hid _chich_ 
specific machine somethign comes from. so I expect that implementation of 
NAT is going tohappen at some point before it's widely deployed.

David Lang
