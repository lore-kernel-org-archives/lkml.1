Return-Path: <linux-kernel-owner+w=401wt.eu-S2992893AbXDYSld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992893AbXDYSld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992896AbXDYSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:41:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992893AbXDYSlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:41:32 -0400
Date: Wed, 25 Apr 2007 14:41:08 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Roland Dreier <rdreier@cisco.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, mst@mellanox.co.il, jackm@mellanox.co.il
Subject: Re: pgprot_writecombine() and PATs on x86
Message-ID: <20070425184108.GB23721@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Roland Dreier <rdreier@cisco.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, mst@mellanox.co.il,
	jackm@mellanox.co.il
References: <ada1wi8xrgt.fsf@cisco.com> <200704252019.28017.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704252019.28017.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:19:27PM +0200, Andi Kleen wrote:
 > On Wednesday 25 April 2007 20:02:26 Roland Dreier wrote:
 > > Hi Eric,
 > > 
 > > Where do your patches to add an implementation of
 > > pgprot_writecombine() using PATs on x86 stand?  
 > 
 > It's on my todo list.

Whats the status on the code at ftp://ftp.firstfloor.org/pub/ak/pat/patches ?
I've not given it much more than a quick skim, so I'm not sure what
it's capable of/what its missing etc..

	Dave

-- 
http://www.codemonkey.org.uk
