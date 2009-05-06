Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbZEFQHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbZEFQHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZEFQHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:07:33 -0400
Received: from sous-sol.org ([216.99.217.87]:59869 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753184AbZEFQHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:07:32 -0400
Date: Wed, 6 May 2009 09:07:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090506160712.GW3036@sequoia.sous-sol.org>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A018DF2.6010301@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> Chris Wright wrote:
> > VF drivers can also have this issue (and typically use mmio).
> > I at least have a better idea what your proposal is, thanks for
> > explanation.  Are you able to demonstrate concrete benefit with it yet
> > (improved latency numbers for example)?
> 
> I had a test-harness/numbers for this kind of thing, but its a bit
> crufty since its from ~1.5 years ago.  I will dig it up, update it, and
> generate/post new numbers.

That would be useful, because I keep coming back to pio and shared
page(s) when think of why not to do this.  Seems I'm not alone in that.

thanks,
-chris
