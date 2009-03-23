Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZCWIl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZCWIl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbZCWIlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:41:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:42602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747AbZCWIlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:41:01 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: ftrace not working?
Date: Mon, 23 Mar 2009 14:08:34 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc8-default; KDE/4.1.3; x86_64; ; )
Cc: =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
References: <200903231208.03723.knikanth@suse.de> <200903231357.41130.knikanth@suse.de> <20090323083533.GE18837@elte.hu>
In-Reply-To: <20090323083533.GE18837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231408.35405.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 14:05:33 Ingo Molnar wrote:
> one thing to note:
> | CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
> | Testing tracer nop: PASSED
>
> so it's a Qemu session, right?
>

Yes. qemu-kvm.

Thanks
Nikanth
