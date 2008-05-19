Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYESSEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYESSEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYESSE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:04:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60635 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753398AbYESSE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:04:26 -0400
Message-ID: <4831C124.2060905@sgi.com>
Date: Mon, 19 May 2008 11:04:20 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
References: <482C9FC5.2070508@cosmosbay.com> <482D1BCE.3060501@cosmosbay.com> <482D8EFC.8040109@sgi.com> <200805171533.46295.rusty@rustcorp.com.au> <482E8AF5.9050804@cosmosbay.com> <Pine.LNX.4.64.0805190940440.18431@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805190940440.18431@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 17 May 2008, Eric Dumazet wrote:
> 
>> Thats a lot of work and apparently Mike and Christoph are doing it.
> 
> Indeed. Thanks for the support. I hope Mike gets the stuff out soon. I 
> know he was working on one issue that cause the zero based stuff to break. 
> Maybe it would help if he would post what he has so far?

I'm re-basing it on the x86/latest tree as sched/latest was failing my tests
last week on both the AMD and Intel boxes.  As soon as I re-verify everything
I'll send it in.

Thanks,
Mike
