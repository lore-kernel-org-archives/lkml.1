Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYLCEMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYLCEMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYLCEMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:12:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38562 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYLCEMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:12:39 -0500
Subject: Re: [RFC PATCH 0/3] A couple of feature requests to the unified
	trace  buffer
From: Steven Rostedt <srostedt@redhat.com>
To: Jiaying Zhang <jiayingz@google.com>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1228275944.4886.43.camel@localhost.localdomain>
References: <5df78e1d0812021652w74c968bboba5e6457059b569b@mail.gmail.com>
	 <1228272731.4886.26.camel@localhost.localdomain>
	 <5df78e1d0812021935h56c2e21am88477ad44a57ec78@mail.gmail.com>
	 <1228275944.4886.43.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 02 Dec 2008 23:12:11 -0500
Message-Id: <1228277531.4886.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 22:45 -0500, Steven Rostedt wrote:

> 
> My splice code is not in git yet. I can put it there tonight. But the
> ring buffer code needed to work with splice is there. The splice work is
> at the ftrace level, but you probably could use the same as well.

OK, I pushed my splice work into the branch:

 tip/splice-broken

And yes, it is still broken ;-)

-- Steve


