Return-Path: <linux-kernel-owner+w=401wt.eu-S934752AbXJLXSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbXJLXSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXJLXKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 19:10:35 -0400
Received: from stinky.trash.net ([213.144.137.162]:37230 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155AbXJLXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 19:02:36 -0400
Message-ID: <470FFD00.9030106@trash.net>
Date: Sat, 13 Oct 2007 01:02:24 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-net@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
References: <200710120031.42805.a1426z@gawab.com> <Pine.LNX.4.64.0710121533360.23981@fbirervta.pbzchgretzou.qr> <470F7B4B.2010609@trash.net> <200710130156.54050.a1426z@gawab.com>
In-Reply-To: <200710130156.54050.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Patrick McHardy wrote:
>   
>> The netlink based iptables successor I'm currently working on allows to
>> dynamically create tables with user-specified priorities and "built-in"
>> chains. The only built-in tables will be those that need extra
>> processing (mangle/nat). So it should be possible to set up tables
>> basically any way you desire.
>>     
>
> Wow!  How soon can we expect this to surface on mainline?

I can't tell at this point, there's still too much work to do
for a realistic estimate. I'll post patches to netfilter-devel
as soon as its good enough for some real testing.

