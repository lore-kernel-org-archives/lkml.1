Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbZEAO1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbZEAO1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZEAO1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:27:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44818 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZEAO1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:27:08 -0400
Date: Fri, 1 May 2009 10:24:55 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       randy.dunlap@oracle.com, wcohen@redhat.com
Subject: Re: [PATCH 0/3] add tracepoints docbook (take #2)
Message-ID: <20090501142455.GA3111@redhat.com>
References: <cover.1241107197.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1241107197.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 01:29:08PM -0400, Jason Baron wrote:
> The following patches add a new tracepoint docbook. Since tracepoints can
> be defined by various macros and in various files, I think it important
> to clearly document the available tracepoints, as Andrew has pointed out.
> This helps us see what we have and what we don't have. If this patch is
> accepted, I hope that others will add docbook style comments, so we can
> have a complete accounting of the kernel's tracepoints.
> 

hi,

i'd also like to get some agreement that future tracepoints need to
have this sort of documentation included when they are submitted. Also,
I'd like people who have already submitted tracepoints to go back and
add this kind of documentation. I'll volunteer to police the effort if
we agree it should be done.

thanks,

-Jason


