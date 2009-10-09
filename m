Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbZJIQ3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbZJIQ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbZJIQ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:29:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbZJIQ3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:29:09 -0400
Subject: Re: move gfs2 tracepoints to inclue/trace/events dir
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jason Baron <jbaron@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091009162051.GB2647@redhat.com>
References: <20091009160115.GA2647@redhat.com>
	 <1255104319.6052.558.camel@localhost.localdomain>
	 <20091009162051.GB2647@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 09 Oct 2009 17:28:41 +0100
Message-Id: <1255105721.6052.559.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-10-09 at 12:20 -0400, Jason Baron wrote:
> On Fri, Oct 09, 2009 at 05:05:19PM +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Fri, 2009-10-09 at 12:01 -0400, Jason Baron wrote:
> > > hi,
> > > 
> > > I'd like to move the gfs2 tracepoints to the the common
> > > include/trace/events directory along with all of the other trace events.
> > > It makes understanding what tracepoints are available easier, and I see
> > > no reason why gfs2 should be different. For example, 'ext4.h' is already
> > > in the include/trace/events directory.
> > > 
> > > thanks,
> > > 
> > > -Jason
> > > 
> > I've no objection to that, it sounds like a good plan. Should I stick
> > this in the GFS2 tree, or would you rather keep it in the trace tree? I
> > was thinking probably the GFS2 tree would be better as it reduces the
> > chances of any future conflicts.
> 
> gfs2 tree works for me.
> 
> thanks,
> 
> -Jason
> 
Ok, done. Should be appearing shortly. Thanks,

Steve.


