Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZI2Hz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZI2Hz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZI2Hz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:55:28 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:55056 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZI2Hz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NRtAkdgJDL+tbRANlbiE9AJZvPfjZf63UobFwPlNa9pFtrHeKnzLCJK5hgG7/hJATn
         NtMqFUAFS8i8tTZ7oQglcYV920tPGdekkux8giMqMYGRzjKT97uPCgsi9cjq7ICmt6QK
         qKXxAwAeNvQmwHWeeeT/vJeFDc6AgIniB1kPU=
Date: Tue, 29 Sep 2009 09:55:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] tracing: Pushdown the bkl tracepoints calls
Message-ID: <20090929075530.GB5233@nowhere>
References: <1254152315-10324-1-git-send-email-fweisbec@gmail.com> <20090928154304.GA9724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928154304.GA9724@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 05:43:04PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull this patch from
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/core
> > 
> > It should fix the crash you have reported few days ago.
> 
> Hm, nothing in that branch - forgot to push out?
> 
> 	Ingo


Indeed :-)

Sorry, it should be pushed out now. 

Thanks.

