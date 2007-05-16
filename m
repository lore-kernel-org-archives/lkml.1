Return-Path: <linux-kernel-owner+w=401wt.eu-S934193AbXEPU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbXEPU41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbXEPU4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:56:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:18674 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbXEPU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:56:18 -0400
Subject: Re: v2.6.21-rt2
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20070516180447.GA17922@elte.hu>
References: <20070516180447.GA17922@elte.hu>
Content-Type: text/plain
Date: Wed, 16 May 2007 13:54:02 -0700
Message-Id: <1179348842.20519.20.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 20:04 +0200, Ingo Molnar wrote:
> i'm pleased to announce the v2.6.20-rt2 kernel, which can be downloaded 
> from the usual place:

2.6.21-rt2 ?

>     http://redhat.com/~mingo/realtime-preempt/
>                                    
> more info about the -rt patchset can be found in the RT wiki:
>  
>     http://rt.wiki.kernel.org
> 
> This is a fixes-mostly release and has been assembled by Thomas 
> Gleixner. Thanks Thomas! Here are the various changes:
> 
>   - ppc fixes from Tsutomu OWA
> 
>   - new sh -rt port from Paul Mundt & Co
> 
>   - fixes for various problems by Steven Rostedt and Clark Williams

I think you missed the fix I submitted for one of Steve's changes.

http://lkml.org/lkml/2007/5/3/368

Daniel

