Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZJSPDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZJSPDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZJSPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:03:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbZJSPDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:03:32 -0400
Date: Mon, 19 Oct 2009 17:03:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/7] acpi: fix a bunch of style issues on 'actypes.h'
In-Reply-To: <94a0d4530910190757y139c7e20xe6a58f0cbf13a79d@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0910191658260.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>  <1255906474-25091-6-git-send-email-felipe.contreras@gmail.com>  <alpine.LSU.2.00.0910191616290.8582@wotan.suse.de> <94a0d4530910190757y139c7e20xe6a58f0cbf13a79d@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> > I have never been in favor of merging whitespace-only patches (in a 
> > sense that the sole purpose of them being to change whitespaces, but 
> > no else value added).
> If somebody tries to send a patch for that file that doesn't fix the
> white-space, checkpatch will complain, and people will complain that
> checkpatch complains, which is precisely what happened, 

Oh, well ... checkpatch warning about this is somewhat controversial. My 
preferred way would be that it warns about whitespace only if there are 
also some other (non-whitespace) changes.

> and I was requested to write this patch by Daniel Walker (final mail 
> wasn't on the ml):
> 
> http://lkml.org/lkml/2009/9/14/183

This is something slightly different -- he asks you to fixup whitespace 
issue in the code you are newly introducing, right?

> > And after today's discussion on kernel summit on this topic, I wouldn't
> > expect any maintainer to merge it, sorry :)
> What are you talking about?

Seems like many kernel maintainers are just tired of 
'whitespace-cleanup-only' patches that bring no real added value 
otherwise.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
