Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZDIOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZDIOSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZDIOSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:18:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZDIOSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:18:37 -0400
Message-ID: <49DE038B.2060107@redhat.com>
Date: Thu, 09 Apr 2009 10:17:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "lee.schermerhorn" <lee.schermerhorn@hp.com>,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: move the scan_unevictable_pages sysctl to the vm
 table
References: <1239270133.7647.213.camel@twins>
In-Reply-To: <1239270133.7647.213.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Subject: mm: move the scan_unevictable_pages sysctl to the vm table
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Apr 09 11:38:45 CEST 2009
>
> vm knobs should go in the vm table. Probably too late for randomize_va_space
> though.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>   
Dunno if the merge error is mine or someone else's or if
we should all blame patch, but ...

Acked-by: Rik van Riel <riel@redhat.com>
