Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZFJTBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZFJTBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZFJTBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:01:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44945 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZFJTBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:01:13 -0400
Date: Wed, 10 Jun 2009 15:00:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
       research@subreption.com, davem@davemloft.net, riel@redhat.com
Subject: mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization
	(was Re: 2.6.31 -mm merge plans)
Message-ID: <20090610190005.GD3892@tuxdriver.com>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 11:51:40AM -0700, Andrew Morton wrote:
> 
> Please rewrite the Subject: and add appropriate cc's when replying to
> this email.

> mac80211-use-kzfree-in-key-handling-to-enforce-data-sanitization.patch
> 
>  -> wireless

Johannes had some objections to this patch as it is currently written...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
