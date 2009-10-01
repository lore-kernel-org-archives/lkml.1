Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZJAVRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZJAVRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZJAVRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:17:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59796 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZJAVRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:17:20 -0400
Subject: Re: INFO: task kjournal:337 blocked for more than 120 seconds
From: Shirley Ma <mashirle@us.ibm.com>
To: Javier Guerra <javier@guerrag.com>
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mcao@us.ibm.com
In-Reply-To: <90eb1dc70910011403q31218381tec865b1ecd361eff@mail.gmail.com>
References: <1254345112.8837.9.camel@localhost.localdomain>
	 <20091001132012.GA16975@amt.cnet>
	 <1254416336.6787.6.camel@localhost.localdomain>
	 <1254430820.5033.4.camel@localhost.localdomain>
	 <90eb1dc70910011403q31218381tec865b1ecd361eff@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 14:17:21 -0700
Message-Id: <1254431841.5033.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 16:03 -0500, Javier Guerra wrote:
> deadline is the most recommended one for virtualization hosts.  some
> distros set it as default if you select Xen or KVM at installation
> time.  (and noop for the guests)

I spoke too earlier, after a while noop scheduler hit the same issue. I
am switching to deadline to test it again.

Thanks
Shirley

