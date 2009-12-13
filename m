Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZLMVTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZLMVTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbZLMVTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:19:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:26319 "HELO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754221AbZLMVS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RjZodmc4Bm1wiC/vtJDMoTn84tZSS1JDmZ2rYyjSTdd19QccX3oWFaxHEm3HWGjNZm
         P4N5O4PBVPU2JxvI7cI560krWVUqjbB355O6GPToPX7g6acMCI4twUGOV2siCJPFHbRu
         5en1p4uTTZH1/5xg8yyDBo25Y61OHh4y7FGV8=
Date: Sun, 13 Dec 2009 22:18:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL] tracing updates
Message-ID: <20091213211852.GA5220@nowhere>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 02:08:01PM +0100, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the tracing/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core


You can also pick up tracing/urgent. This is the same
patchset but rebased on tip:tracing/urgent.

Thanks.

