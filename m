Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZDQVcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZDQVcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZDQVcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:32:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:49204 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZDQVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:32:35 -0400
Message-ID: <49E8F4F9.7070106@oracle.com>
Date: Fri, 17 Apr 2009 14:30:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc updates
References: <1239167872-8179-1-git-send-email-joe@perches.com>	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost>
In-Reply-To: <1240003652.31116.44.camel@localhost>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49E8F4EF.0139:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Fri, 2009-04-17 at 13:47 -0700, Randy Dunlap wrote:
>> On Tue,  7 Apr 2009 22:17:42 -0700 Joe Perches wrote:
>> I was hoping to get the patch that changed all pairs of
>> P:
>> M:
>> lines to one line that is suitable for pasting into email addresses.
>> Are we supposed to use get_maintainer.pl for that?
> 
> I merely wanted to get the patterns accepted.
> 
> I thought the P/M: integration was an unnecessary
> complication that would delay pattern acceptance.
> 
> So I use scripts/get_maintainer.pl "as is".
> Suggestions on improvements to the script are
> of course gladly accepted...
> 
> If the script doesn't work well for you, please
> let me know.
> 
> If the P/M: conversion is desired, I've no objection.
> The script would have to change though.
> 
> There are command line options to control email address
> output style:
> 
> For instance:

OK, thanks, I'll try to use it as is.

-- 
~Randy
