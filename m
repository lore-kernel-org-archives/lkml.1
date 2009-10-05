Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZJEWJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZJEWJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZJEWJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:09:39 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:65358 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbZJEWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pNnItd9dMLnR165rW0TydHOeVb9UESt3aBZxrVk794UsHl+YPeqRQZx1nCJLjXD9ho
         AKbZZAXi1SDDf8qFMX/tTJf/z4tgSxkm9c3RKXTvCkcVoZH4UXEX/VKzG1GF9ppuFO42
         UZ5k0H0VVG66pGv22csX+s8dHAaPtOU7p2g5M=
Date: Tue, 6 Oct 2009 00:09:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091005220859.GI6071@nowhere>
References: <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com> <20091005205826.GE6071@nowhere> <4ACA60E9.30404@redhat.com> <20091005212137.GG6071@nowhere> <4ACA6660.7020607@redhat.com> <20091005215548.GH6071@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005215548.GH6071@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 11:55:50PM +0200, Frederic Weisbecker wrote:
> In this case, we should rather have %%register and %arg0 :)

And the above construct would be so much not obvious in its self
meaning, wrt its gcc inline inspiration.

/me should stop quibbling...

