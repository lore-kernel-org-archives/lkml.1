Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbYLDTTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbYLDTTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYLDTTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:19:25 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57684 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYLDTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:19:24 -0500
Date: Fri, 5 Dec 2008 00:47:58 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces - v2
Message-ID: <20081204191758.GJ20563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204190804.GA15134@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 12:38:05AM +0530, K.Prasad wrote:
> Hi All,
> 	Please find the latest set of patches that introduce kernel
> interfaces to use Hardware Breakpoint registers and an implementation
> for x86 (and x86_64) architecture.
> 
> The patches have undergone changes to incorporate the suggestions for
> the previous patchset - including removal of support for instruction
> breakpoint, and are based off 2.6.28-rc7. The patches have been tested
> on x86 architecture along with kprobes, however they're posted as RFC
> owing to the many pending tasks (refer
> http://lkml.org/lkml/2008/10/7/127 for details).
> 
> Thanks,
> K.Prasad
>
Oops...the title should have read: [RFC Patch 0/9] Hardware Breakpoint
interfaces - v3
 
