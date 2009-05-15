Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZEOAUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZEOAUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZEOAT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:19:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:60207 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbZEOAT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:19:58 -0400
Date: Fri, 15 May 2009 10:17:56 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Theodore Tso <tytso@mit.edu>
cc: Joseph Cihula <joseph.cihula@intel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, chrisw@sous-sol.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com,
       John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
In-Reply-To: <20090512210154.GC23773@mit.edu>
Message-ID: <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Theodore Tso wrote:

> So we should expect a certain amount of controversy and people
> lobbying to resist the acceptance of this patch.

FWIW, here's my response to an earlier private enquiry from John on the 
topic:

  I'd prefer discussion to be public, so I don't mind leaving more 
  detailed discussion to that.

  There has been considerable discussion on the issue, following Linus' 
  statement (which I'm sure you're aware of):

  http://marc.info/?l=linux-kernel&m=105115686114064&w=2

  My position is similar -- people can decide for themselves whether they 
  want to use DRM technology.  I'm also confident that technical measures 
  taken to prevent real freedom will always be broken (when have they ever 
  not been?)

  I also feel there may be genuinely useful applications of some of the 
  technology (e.g. sealing disk encryption keys in the TPM a la 
  BitLocker).


I'm fairly neutral on the technology itself and feel that "market 
pressure" from users as well as local regulatory policy (e.g. anti-trust 
laws) should determine how the technology is used, rather than the views 
of a few kernel hackers.


- James
-- 
James Morris
<jmorris@namei.org>
