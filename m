Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZE1BPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZE1BPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZE1BOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:14:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:42829 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbZE1BOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:14:53 -0400
Date: Thu, 28 May 2009 11:12:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
cc: Joe Perches <joe@perches.com>, Theodore Tso <tytso@mit.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>,
       John Gilmore <gnu@toad.com>
Subject: RE: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D99B475314@orsmsx506.amr.corp.intel.com>
Message-ID: <alpine.LRH.2.00.0905281100590.30090@tundra.namei.org>
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu>  <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org>  <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com> <1242352277.646.16.camel@Joe-Laptop.home>
 <4F65016F6CB04E49BFFA15D4F7B798D99B475314@orsmsx506.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW,

There are some new slides from a talk by the InvisbleThings folk on this 
topic which should help people understand some of the benefits and 
pitfalls of this technology at a high level:

http://theinvisiblethings.blogspot.com/2009/05/thoughts-about-trusted-computing.html


-- 
James Morris
<jmorris@namei.org>
