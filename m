Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbXFZMjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbXFZMjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbXFZMjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:39:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:22870 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbXFZMjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:39:35 -0400
Message-ID: <4681090A.6030805@sw.ru>
Date: Tue, 26 Jun 2007 16:39:38 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>	<6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>	<467B2F4F.2030101@openvz.org>	<6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>	<661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com> <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com>
In-Reply-To: <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 6/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>The problem with input in bytes is that the user will have to ensure
>>that the input is
>>a  multiple of page size, which implies that she would need to use the
>>calculator every time.
>>
> 
> 
> Having input in bytes seems pretty natural to me. Why not just have
> the RSS controller round the input to the nearest page (or whatever
> granularity of memory the controller is able to limit at)?

totally agree with Paul.

Kirill

