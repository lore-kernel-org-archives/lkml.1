Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYFXQXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYFXQXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYFXQX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:23:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56217 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYFXQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:23:26 -0400
Date: Wed, 25 Jun 2008 01:21:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
Cc: kosaki.motohiro@jp.fujitsu.com,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
In-Reply-To: <48611B03.1000003@redhat.com>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com>
Message-Id: <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tracepoint
>  - stored in a section
>  - dynamic activation
>  - no message
>  - export kernel structure
>  - arguments depending on points
>  - high frequently called
>  - no module support (kernel use only)

Why Shouldn't kernel module use tracepoint?
technical problem? or any plicy exist?


