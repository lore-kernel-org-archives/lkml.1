Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbZCSNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbZCSNe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZCSNer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:34:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64235 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZCSNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:34:46 -0400
Date: Thu, 19 Mar 2009 09:34:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range()
In-Reply-To: <20090319132248.GA20200@Krystal>
Message-ID: <alpine.DEB.2.00.0903190933440.16987@gandalf.stny.rr.com>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com> <20090319074616.GA17144@elte.hu> <20090319132248.GA20200@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 19 Mar 2009, Mathieu Desnoyers wrote:
> 
> Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
> directory which have the correct version, but the wrong module.h header ?

Isn't there a module versioning that prevents such things?

-- Steve
