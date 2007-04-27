Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbXD0GCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbXD0GCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXD0GCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:02:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:44875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbXD0GCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:02:09 -0400
From: Neil Brown <neilb@suse.de>
To: Ulrich Drepper <drepper@redhat.com>
Date: Fri, 27 Apr 2007 16:01:55 +1000
Message-ID: <17969.37331.20590.635169@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
In-Reply-To: message from Ulrich Drepper on Thursday April 26
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com>
	<17969.22692.855242.359680@notabene.brown>
	<46315C61.30001@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 26, drepper@redhat.com wrote:
> Neil Brown wrote:
> > Does it also specify how to find out what granularity is used by the
> > filesystem?  I had a need for this just recently and couldn't see any
> > way to extract it.
> 
> That's still on the table.  We might end up with an fpathconf() solution.

Ok, that makes sense.  Thanks.  Glad it is under consideration.

NeilBrown
