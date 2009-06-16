Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbZFPV4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbZFPV4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762939AbZFPV4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:56:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56656 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZFPV4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:56:20 -0400
Message-ID: <4A3814E0.9080607@redhat.com>
Date: Tue, 16 Jun 2009 17:55:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] mm: make swap token dummies static inlines
References: <Pine.LNX.4.64.0906162152250.12770@sister.anvils> <1245189037-22961-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1245189037-22961-1-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Make use of the compiler's typechecking on !CONFIG_SWAP as well.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
