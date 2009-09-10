Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZIJW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZIJW5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 18:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZIJW5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 18:57:39 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38835 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZIJW5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 18:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IAs2pgFX3G/5BQh1MVPjs1SFG+mrnjdcP0NMbYkIRbKLdm5FUBYW3jjyR4uZT/inqZ
         dWzsOAF2fRVv4xiSJ9VowcuWvZ1iurk40hUE05C1Auf3N0zWULbArT2K9wK0/ekZROFw
         bMMz+PdHTL9B0SmOAz7aXpPrbAqyYL63WGEDw=
Date: Fri, 11 Sep 2009 00:57:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH tracing/kprobes] x86: Add MMX support for instruction
	decoder
Message-ID: <20090910225735.GA16396@nowhere>
References: <20090904190651.GC6118@nowhere> <20090908163246.23516.78835.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908163246.23516.78835.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 12:32:46PM -0400, Masami Hiramatsu wrote:
> Add MMX/SSE instructions to x86 opcode maps, since some of those
> instructions are used in the kernel.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---


Hehe :) 

	"Succeed: decoded and checked 1574884 instructions"

I'm taking the three patches, thanks!

