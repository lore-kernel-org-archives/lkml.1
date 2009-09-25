Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZIYITR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZIYITR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZIYITP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:19:15 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:30435 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZIYITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:19:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20090924213631.GA2661@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	 <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
	 <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere>
	 <1253825489.18939.180.camel@laptop>  <20090924213631.GA2661@nowhere>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 10:19:52 +0200
Message-Id: <1253866792.10287.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 23:36 +0200, Frederic Weisbecker wrote:

> > Remember, there are no second chances for the filter syntax anymore.
> 
> 
> But well, it's not yet an ABI. It's still a baby, although powerful
> for filtering, it's not yet a whole scripting language.
> 
> Before thinking about it as an ABI, we should develop it, extend
> it, use these extensions, spot the weaknesses in the syntax, fix them,
> etc...

Then this is a NACK for the perf ioctl for setting a filter. Fine with
me.


