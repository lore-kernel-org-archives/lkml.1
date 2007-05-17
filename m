Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXEQMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXEQMvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXEQMvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:51:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37044 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbXEQMvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:51:38 -0400
Date: Thu, 17 May 2007 07:51:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       jeffschroeder@computer.org, Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 0/2] file capabilities: Introduction
Message-ID: <20070517125131.GA23067@sergelap.austin.ibm.com>
References: <20070508191548.GA29913@sergelap.austin.ibm.com> <20070508130517.ecef3dcb.akpm@linux-foundation.org> <20070514200011.GB3969@ucw.cz> <20070517055747.GA15474@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517055747.GA15474@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Suparna Bhattacharya (suparna@in.ibm.com):
> On Mon, May 14, 2007 at 08:00:11PM +0000, Pavel Machek wrote:
> > Hi!
> > 
> > > "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > > 
> > > > Following are two patches which have been sitting for some time in -mm.
> > > 
> > > Where "some time" == "nearly six months".
> > > 
> > > We need help considering, reviewing and testing this code, please.
> > 
> > I did quick scan, and it looks ok. Plus, it means we can finally start
> > using that old capabilities subsystem... so I think we should do it.
> 
> FWIW, I looked through it recently as well, and it looked reasonable enough
> to me, though I'm not a security expert. I did have a question about
> testing corner cases etc, which Serge has tried to address.
> 
> Serge, are you planning to post an update without STRICTXATTR ? That should
> simplify the second patch.

Sorry, I did but I guess I didn't cc: you on that reply.

It is at http://lkml.org/lkml/2007/5/14/276

thanks,
-serge
