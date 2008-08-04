Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYHDO4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYHDO4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYHDO4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:56:23 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:58614 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYHDO4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:56:22 -0400
Message-ID: <38597.166.70.238.45.1217860550.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48971137.7090903@s5r6.in-berlin.de>
References: <37460.166.70.238.45.1217831665.squirrel@webmail.wolfmountaingroup.com>
    <48971137.7090903@s5r6.in-berlin.de>
Date: Mon, 4 Aug 2008 08:35:50 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc1 11/25] mdb:  Merkey's Kernel Debugger 
     2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com wrote:
>> --- a/debug/mdb-ia32-support.c	1969-12-31 17:00:00.000000000 -0700
>> +++ b/debug/mdb-ia32-support.c	2008-08-03 16:15:00.000000000 -0600
> [...]
>> +BYTE *output_jmp_address(StackFrame *stackFrame, long val, long *delta)
>
> This one is a challenge to read.  :-)
> At least in MUAs which can't collapse C code nesting levels...
> --
> Stefan Richter
> -=====-==--- =--- --=--
> http://arcgraph.de/sr/
>

Getting those arrows int jump labels was some work, I admit.

Jeff

