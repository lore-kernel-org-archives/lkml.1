Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbZABXDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbZABXDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZABXCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:02:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:30962 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbZABXCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ixsGMBDhForX3cRBFrbIiuW/0fYWb+D/FRj/u8uyWci6LR7HupFKAs4tVnLQXY+DW2
         yhpO9HKaLpDwGNGDbz9+xZsBon4F7WGQNkBS6DfZk5q0quvHK/EUU+45nvTw5cgC5j+z
         NOvUd4on910zuPNRMR0cLGKDO07LQ8ZH+mU/Y=
Date: Sat, 3 Jan 2009 01:03:14 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090102230314.GC5235@localhost>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <84144f020812290144q38aca42bw1e84d38b3dad2a08@mail.gmail.com> <20090102205426.GC25473@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102205426.GC25473@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 03:54:26PM -0500, Mathieu Desnoyers wrote:
> * Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> > On Mon, Dec 29, 2008 at 3:40 AM, Eduard - Gabriel Munteanu
> > <eduard.munteanu@linux360.ro> wrote:
> > > kmemtrace now uses tracepoints instead of markers. We no longer need to
> > > use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
> > > it's easy to pass -1 as the NUMA node without providing a needless and
> > > long-named variant of the same function.
> > >
> > > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > 
> > Looks good to me. Mathieu, does this look sane to you as well?
> > 
> 
> Just got back from vacation. Just replied to it.
> 
> Happy new year :)
> 
> Mathieu

Thanks for pitching in. Happy new year!


	Cheers,
	Eduard

