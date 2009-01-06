Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbZAFAdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbZAFAdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZAFAdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:33:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:9805 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZAFAdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t2D2lGLoXLFAqHiFEjKSEyA7qDNH3A5cpIQsUDkoyTRPjXtX6CZ8gRq7B83KAFe3N1
         m3mUu8Z21qhkB22lj3IzKhNXe1MesomxadyclDY4ksjmFPu1AKY70bsXfyZ2CZzLn1+y
         7+is5guzmT8FeE+WBkyQ09i0Jm14EC1n3Uhcc=
Date: Tue, 6 Jan 2009 01:33:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/2] tracing/ftrace: provide the base infrastructure
	for stat tracing
Message-ID: <20090106003304.GE6531@nowhere>
References: <4956aff1.0405560a.0eb9.ffffd126@mx.google.com> <alpine.DEB.1.10.0901051047030.27085@gandalf.stny.rr.com> <c62985530901050857q4d1a04kf9a5078477fef4bc@mail.gmail.com> <alpine.DEB.1.10.0901051203150.27085@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051203150.27085@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 12:04:57PM -0500, Steven Rostedt wrote:
> 
> On Mon, 5 Jan 2009, Fr?d?ric Weisbecker wrote:
> > 
> > So I don't know how it will be better to fix what you pointed out
> > here. By making a delta patch on top of the current one and rebasing
> > the next one, or by making a delta on top of the next one...?
> > Ingo, what would you prefer?
> > 
> 
> This is a critical bug, I would make it a separate patch and then Ingo can 
> get it in right away.
> 
> Thanks,
> 
> -- Steve
>

Ok, I will send the fix tomorrow.

Thanks.

