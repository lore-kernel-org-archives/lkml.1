Return-Path: <linux-kernel-owner+w=401wt.eu-S1762425AbYAQWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762425AbYAQWxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760841AbYAQWmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:42:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36044 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760938AbYAQWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:42:35 -0500
Message-ID: <478FD9D9.7030009@sgi.com>
Date: Thu, 17 Jan 2008 14:42:33 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: Reduce memory and intra-node effects with large
 count NR_CPUs fixup
References: <20080117223546.419383000@sgi.com>
In-Reply-To: <20080117223546.419383000@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

My automatic scripts accidentally sent this mail prematurely.  Please hold
off applying yet.

Thanks,
Mike

travis@sgi.com wrote:
> Fixup change NR_CPUS patchset by rebasing on 2.6.24-rc8-mm1 (from 2.6.24-rc6-mm1)
> and adding last minute changes suggested by reviews.
> 
> Based on 2.6.24-rc8-mm1
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
> ---
> 

