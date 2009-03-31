Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZCaHBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZCaHBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZCaHBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:01:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:1305 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZCaHBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:01:39 -0400
Date: Tue, 31 Mar 2009 18:00:16 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Joseph Cihula <joseph.cihula@intel.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       chrisw@sous-sol.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v2][PATCH 0b/1] intel_txt: Intel(R) Trusted Execution
 Technology support for Linux - Details
In-Reply-To: <49D1A6A5.8080501@intel.com>
Message-ID: <alpine.LRH.2.00.0903311752260.13053@tundra.namei.org>
References: <49D1A6A5.8080501@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Joseph Cihula wrote:

>   -  If tboot determines that the system does not support Intel TXT or is not
>      configured correctly (e.g. the SINIT AC Module was incorrect), it will
>      directly launch the kernel with no changes to any state.

AC means "authenticated code", right?

How readily can these be redistributed?  The license says:

"... you may make a reasonable number of copies of the Software for 
internal use only, subject to these conditions: 
1. You may not copy, modify, rent, sell, distribute, externally display,
   externally perform or transfer any part of the Software except as provided
   in this Agreement, and you agree to prevent unauthorized copying of the
   Software.  "

which seems to limit the ability of distributions to include the modules, 
in case they're redistributed.


- James
-- 
James Morris
<jmorris@namei.org>
