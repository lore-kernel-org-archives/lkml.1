Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbXEJXIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbXEJXIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759827AbXEJXIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:08:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43219 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754359AbXEJXIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:08:09 -0400
Date: Fri, 11 May 2007 09:07:55 +1000
From: David Chinner <dgc@sgi.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510230755.GG86004887@sgi.com>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464393E1.3050705@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:51:29PM -0400, Chuck Ebbert wrote:
> Jeremy Fitzhardinge wrote:
> > Chuck Ebbert wrote:
> >> What CPU architecture is this happening on? Not i686 with PAE by
> >> any chance?
> > 
> > Yes.  Why?
> 
> I have a bug report where NFS files are corrupted only with PAE clients.
> Corruption is at the end of the (newly untarred) files. Doesn't happen
> without PAE.

Chuck, can you post a pointer to this thread?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
