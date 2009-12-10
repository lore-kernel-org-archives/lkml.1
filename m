Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbZLJVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbZLJVyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761836AbZLJVyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:54:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761831AbZLJVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:54:38 -0500
Date: Thu, 10 Dec 2009 16:54:42 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 2/5] parisc: Convert BUG() to use unreachable()
Message-ID: <20091210215442.GB28962@bombadil.infradead.org>
References: <4B212EEC.3060808@caviumnetworks.com> <1260466101-17545-2-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260466101-17545-2-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 09:28:18AM -0800, David Daney wrote:
> Use the new unreachable() macro instead of for(;;);
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> CC: Kyle McMartin <kyle@mcmartin.ca>
> CC: Helge Deller <deller@gmx.de>
> CC: linux-parisc@vger.kernel.org
> ---

Thanks David, I'll bash this into my tree now that the macro is
upstream.

regards, Kyle
