Return-Path: <linux-kernel-owner+w=401wt.eu-S1766990AbXDSVEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766990AbXDSVEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766988AbXDSVEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:04:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766990AbXDSVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:04:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
Date: Thu, 19 Apr 2007 23:04:00 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070414204154.871250608@goop.org> <200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
In-Reply-To: <4627D756.5020405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192304.01053.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 22:55:50 H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> Is some version of this going in for 2.6.21, or is it not a real problem?
> > 
> > When it's only seen with Xen it's not a real problem right now.
> 
> It's not just seen only with Xen, though.  It will affect all kernels in 
> a particular range of sizes, and we have ordinary kernels covering that 
> range (in fact, Xen hardly affects size in that way.)

Then we would have seen reports surely?

-Andi
