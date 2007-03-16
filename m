Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXCPC2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXCPC2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXCPC2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:28:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36067 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbXCPC2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:28:10 -0400
Date: Fri, 16 Mar 2007 07:57:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Ian Campbell <Ian.Campbell@xensource.com>
Cc: Horms <horms@verge.net.au>, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Message-ID: <20070316022739.GA10515@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <1173891609.8591.41.camel@localhost.localdomain> <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com> <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com> <1173961378.8591.63.camel@localhost.localdomain> <20070315132616.GH6766@in.ibm.com> <1173966159.8591.82.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173966159.8591.82.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 01:42:39PM +0000, Ian Campbell wrote:
> On Thu, 2007-03-15 at 18:56 +0530, Vivek Goyal wrote:
> > 
> > Ideal place for this probably should have been arch dependent
> > crash_dump.h file. But we don't have one and no point introducing one
> > just for this  macro.
> 
> Agreed.
> 
> > This change looks good to me. 
> 
> Is there a kdump tree which you'll apply to or shall I resend CCing
> apkm? (I'll add an Acked-by if that's ok).
> 

There is no separate kdump tree. Generally Andrew picks up these changes.
I guess just resend it copying Andrew. Yes you can add Acked-by me.

Thanks
Vivek
