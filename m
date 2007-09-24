Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbXIXUoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbXIXUoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXIXUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:44:17 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:60959 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXIXUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:44:16 -0400
Date: Mon, 24 Sep 2007 16:44:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-rt-users@vger.kernel.org
Message-ID: <20070924204408.GA4748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-rt-users@vger.kernel.org
Bcc: 
Subject: Re: realtime preemption performance difference
Reply-To: 
In-Reply-To: <3f9a31f40709240448h4a9e8337t437328b5c675ecd5@mail.gmail.com>

On Mon, Sep 24, 2007 at 05:18:01PM +0530, Jaswinder Singh wrote:
> Hi all,
> 
> I want to check performance difference by using realtime preemption patch :
> 
> http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Please let me know from where I can download samples to test realtime
> preemption performance difference.
> 
> Can someone please share performance numbers for your hardware:-
> 
> 1. Interrupt latency
> 2. Task switching time
> 3. hard-realtime scheduling latency
> 

see http://rt.wiki.kernel.org/index.php/Main_Page

There's also an RT mailing list for users (CC'd).

-- Steve
