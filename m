Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356Ab0ARRLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0ARRLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226Ab0ARRLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:11:51 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38072 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab0ARRLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:11:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qvh4LK1L2CntRsHUIHBZ/CzZ78fkpW1edNfYT8Oh/4vseMiJ2snH09Q0vuUZ9xjlAX
         jZIHg6X85H7tPhgUKR3WOaJtuCHZDx6rEaxEnLKtm+N9LeLe7qnrXpD69NbTVRGEjBUO
         b5jyFZ4yr+a0a956ntmwRgORGxXUAODge2d2I=
Date: Mon, 18 Jan 2010 18:11:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer
	operation
Message-ID: <20100118171144.GK10364@nowhere>
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5465D8.9070203@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 09:44:56PM +0800, Xiao Guangrong wrote:
> Introduce ftrace_profile_buf_begin() and ftrace_profile_buf_end() to
> operate event profile buffer, clean up redundant code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---


Looks good, nice and desired cleanup, thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

