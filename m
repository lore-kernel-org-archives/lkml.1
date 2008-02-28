Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbYB1E6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbYB1E6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 23:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYB1E6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 23:58:11 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41880 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYB1E6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 23:58:10 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5239"; a="963033"
Message-ID: <47C63F5E.7090005@qualcomm.com>
Date: Wed, 27 Feb 2008 20:58:06 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/4] cpuset: system sets
References: <20080227222103.673194000@chello.nl> <20080227222542.311184000@chello.nl> <47C5F7D6.2000203@qualcomm.com> <20080227181129.59086769.pj@sgi.com> <Pine.LNX.4.58.0802271928430.9072@gandalf.stny.rr.com> <47C6124E.6020305@qualcomm.com> <Pine.LNX.4.58.0802272234580.11356@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0802272234580.11356@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> On Wed, 27 Feb 2008, Max Krasnyanskiy wrote:
> 
>> Steven Rostedt wrote:
>>
>> Thunderbird. The patches were actually attached. Thunderbird does show
>> them inline but when you hit reply it's an empty message.
> 
> Nope, Thunderbird simply got fooled by the added header line:
> 
>  Content-Disposition: inline; filename=cpuset-system.patch
> 
> These patches were sent by quilt...
> 
>   User-Agent: quilt/0.45-1
> 
> and as such are the proper way to send patch series.
> 
> I pulled this up in Thunderbird, hit reply and it kept the patch. Perhaps
> your options are not set up correctly, or you need to upgrade your
> Thunderbird.

Interesting. I got Thunderbird 2.0.0.9 here, came with the latest Fedora 8 updates.
This is the first series of patches it does that for me. Stuff sent by git-send-email 
for example comes out just fine. I looked through content handling options and do no 
see anything obvious.
Anyway. Sorry for the complaint.

Max
