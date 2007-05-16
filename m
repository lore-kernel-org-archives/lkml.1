Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXEPR10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXEPR10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXEPR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:27:17 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:10840 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbXEPR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:27:16 -0400
Date: Wed, 16 May 2007 18:26:53 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
In-Reply-To: <464B3BE4.10704@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705161823550.16760@blonde.wat.veritas.com>
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>
 <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com>
 <20070515144007.f87d9be5.akpm@linux-foundation.org> <464A533B.8040507@yahoo.com.au>
 <Pine.LNX.4.64.0705161711090.7914@blonde.wat.veritas.com> <464B3BE4.10704@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 16 May 2007 17:27:15.0357 (UTC) FILETIME=[723ED4D0:01C797DF]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBkaG93ZWxsc0ByZWRoYXQuY29tAG5pY2twaWdnaW5AeWFob28uY29tLmF1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Nick Piggin wrote:
> 
> ... and I don't want to change the
> VM in a way that people are not unhappy with :)

I'm hoping you intended one less negative ;)
