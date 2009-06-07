Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZFGK1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZFGK1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZFGK1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:27:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46631 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbZFGK1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:27:44 -0400
Date: Sun, 7 Jun 2009 12:35:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH] KVM: Add VT-x machine check support v2
Message-ID: <20090607103514.GA22266@one.firstfloor.org>
References: <20090605232356.GA7091@basil.nowhere.org> <4A2B57B9.7070207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2B57B9.7070207@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 09:01:29AM +0300, Avi Kivity wrote:
> >v2: Handle machine checks still in interrupt off context
> >to avoid problems on preemptible kernels.
> >
> >Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> >  
> 
> Only applies with -C0.  What tree was this generated against?

2.6.30-rc7

> Please diff and test against latest kvm.git.

Sorry can't do neither for the next two weeks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
