Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZJBFLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZJBFLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZJBFLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:11:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:51829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbZJBFLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:11:39 -0400
Message-ID: <4AC58B88.8010602@suse.de>
Date: Fri, 02 Oct 2009 14:11:36 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic percpu
 and drop the old one, take#2
References: <1253682382-24740-1-git-send-email-tj@kernel.org>
In-Reply-To: <1253682382-24740-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> This is the second take of convert-ia64-to-dynamic-percpu patchset.
> Changes from the last take[L] are

Patchset pushed out for linux-next with Rusty and Tony's acks added.

Thanks.

-- 
tejun
