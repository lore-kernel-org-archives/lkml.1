Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0BMEMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 23:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0BMEMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 23:12:18 -0500
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <srostedt@redhat.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B7620BD.4070307@am.sony.com>
References: <4B733721.3030503@am.sony.com>  <4B7338BF.1070505@am.sony.com>
	 <1265929831.2737.340.camel@localhost.localdomain>
	 <4B749A42.2080703@am.sony.com>
	 <1265934415.2737.344.camel@localhost.localdomain>
	 <4B7620BD.4070307@am.sony.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 12 Feb 2010 23:12:13 -0500
Message-Id: <1266034333.2737.349.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 19:47 -0800, Tim Bird wrote:
> On 02/11/2010 04:26 PM, Steven Rostedt wrote:

> OK.  Here's what I came up with.  Pretty straightforward.
> Do you want me to integrate this into the previous patch and
> re-send, or just submit this by itself.

I'll fold this into your previous patch.

> 
> My apologies for getting this out so late.  I'll be on
> vacation with my family next week, so if you don't hear
> from me, don't take it as a sign of disinterest. :-)
> 

No prob. I've been quite busy so this is not that high on my priority
list. If you don't hear from me, it is probably because I put it off and
forgot about it. Don't be afraid to ping me about it.

Thanks!

-- Steve




