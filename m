Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZIWLK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZIWLK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZIWLK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:10:56 -0400
Received: from ozlabs.org ([203.10.76.45]:44068 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbZIWLK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:10:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/5] percpu: kill legacy percpu allocator
Date: Wed, 23 Sep 2009 20:40:55 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       "linux-ia64" <linux-ia64@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1253682382-24740-1-git-send-email-tj@kernel.org> <1253682382-24740-6-git-send-email-tj@kernel.org>
In-Reply-To: <1253682382-24740-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909232040.55878.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 02:36:22 pm Tejun Heo wrote:
> With ia64 converted, there's no arch left which still uses legacy
> percpu allocator.  Kill it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Christoph Lameter <cl@linux-foundation.org>

Delightedly-acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
