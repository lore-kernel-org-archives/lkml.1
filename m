Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYEZOhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYEZOhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYEZOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:36:55 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49866 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbYEZOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:36:54 -0400
Message-ID: <483ACAA3.1070705@s5r6.in-berlin.de>
Date: Mon, 26 May 2008 16:35:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Davi Leal <davi@leals.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: I am a volunteer
References: <200805251812.41552.davi@leals.com> <20080525163758.GA1791@cs181133002.pp.htv.fi> <200805252023.22510.davi@leals.com> <20080525194721.GH6749@1wt.eu>
In-Reply-To: <20080525194721.GH6749@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Sun, May 25, 2008 at 08:23:22PM +0200, Davi Leal wrote:
>> Adrian Bunk wrote:
>> > The easiest and very valuable task is testing the kernel as described at
>> >   http://kernelnewbies.org/KernelTesters
>> 
>> I am more motivated to do development than testing.
> 
> And who do you think will test your dev then ?
> 
> Testing very quickly involves development because you will notice bugs
> first, then missing chunks of code to handle special conditions, and by
> this time you will feel much better with kernel internals and will have
> no problem starting on more complex tasks.
[...]

I second what Adrian and Willy wrote, because that's basically how I
became involved.  A driver subsystem which I wanted to use didn't work
quite 100%, so I always checked out the newest sources of the subsystem
development repo and reported open issues or regressions.  When (a)
developers vanished and (b) I became more confident I started to submit
patches myself.

Another conclusion from that is that you should pick an area which
genuinely interests you, i.e. a driver or protocol or whatever which you
actually use yourself frequently.  That's a lot more motivating than to
pick a project from a todo-list at random.
-- 
Stefan Richter
-=====-==--- -=-= ==-=-
http://arcgraph.de/sr/
