Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXGJPlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXGJPlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXGJPlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:41:01 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:59894 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbXGJPlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:41:00 -0400
Message-ID: <4693A87F.2070102@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2007 21:10:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop> <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com> <467B2F4F.2030101@openvz.org> <6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com> <661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com> <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com> <6D63B142.2080404@linux.vnet.ibm.com> <1183981098.1913.22.camel@twins> <46930EAF.6030104@linux.vnet.ibm.com> <20070710082904.b0faaddd.rdunlap@xenotime.net>
In-Reply-To: <20070710082904.b0faaddd.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>> Hmm.. yes.. a library routine would be nice!
> 
> you mean something like lib/cmdline.c::memparse() ?
> 

Excellent, one of the reasons to love Linux (there's already
code) :-)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
