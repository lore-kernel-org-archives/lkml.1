Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZH3Bfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZH3Bfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 21:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZH3Bfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 21:35:54 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:44842 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbZH3Bfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 21:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZEifr7EL3a3wxtIMJpKpU968NbRjOWEf3tyfxfnimEcwIwdv/ZR/1lWSeVKQfyL0tN
         5x6q57JEL5cl2KUZdxKdhLcBAyfBipA00jz3D6EId7DWHoqXk/6FDR2L+nF5GNBm6+YW
         GL8Ld/viYwI3OXd1Sy3nfXV57ymtDZXy5JGgI=
Date: Sun, 30 Aug 2009 03:35:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 1/2] x86: Allow x86-32 instruction
	decoder selftest on x86-64
Message-ID: <20090830013551.GD387@nowhere>
References: <20090827163533.GA30268@elte.hu> <20090828221319.8778.88508.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828221319.8778.88508.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 06:13:19PM -0400, Masami Hiramatsu wrote:
> Pass $(CONFIG_64BIT) to the x86 insn decoder selftest for decoding 32bit code
> on x86-64, which will happen when building kernel with ARCH=i386 on x86-64.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>



Also applied those two, thanks!

