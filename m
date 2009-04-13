Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZDMN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZDMN5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZDMN5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 09:57:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60122 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZDMN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 09:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jn8teFHvegYFNrEw+M/dyBwuMRTl9wqopCsFeicI7qaOzUfJgmefZFNH3JQGEzd/nQ
         BsRiLVf0qGb6ShKgbOhBiDx7bX85uZlJVnuWv2KwLfQkbXE3o4CaIyrk9ogzPkHAjVc0
         /h4Xt9ynC5PsxVTCqTjPP5ppihhRRLvx32AxU=
Date: Mon, 13 Apr 2009 15:57:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] tracing, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090413135700.GA5977@nowhere>
References: <49E28D00.2020803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E28D00.2020803@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 08:53:20AM +0800, Zhaolei wrote:
> Hi,
> 
> I moved workqueue trace to use TRACE_EVENT macro.
> 
> CC: Frederic Weisbecker
> I see in your mail that you will scheduled to do it, but that time I already
> finished it. (I haven't send it to ltml that time because it need apply on top
> of my previous patch which was send but not commited)


This is fine, I have not yet worked on it anyway, I only planned to do it today.
I'm about to review you patches.

Thanks!


> So I just send this patch, you can accept it, or drop it and use yours if is
> is not good.
> 
> Thanks
> Zhaolei
> 

