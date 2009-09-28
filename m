Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZI1DUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZI1DUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 23:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZI1DUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 23:20:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZI1DUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 23:20:21 -0400
Date: Sun, 27 Sep 2009 23:20:19 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH 06/10] parisc: Convert BUG() to use unreachable()
Message-ID: <20090928032019.GJ11961@bombadil.infradead.org>
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-6-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252627011-2933-6-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 04:56:47PM -0700, David Daney wrote:
> Use the new unreachable() macro instead of for(;;);
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> CC: Kyle McMartin <kyle@mcmartin.ca>
> CC: Helge Deller <deller@gmx.de>
> CC: linux-parisc@vger.kernel.org

Since the dependent part of this patch seems to have missed the merge
window, I guess we'll sit on this until next round?

--Kyle
