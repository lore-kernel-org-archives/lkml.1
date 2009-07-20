Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZGTRjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZGTRjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZGTRjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:39:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58789 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZGTRjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:39:33 -0400
Message-ID: <4A64ABA2.4010200@redhat.com>
Date: Mon, 20 Jul 2009 13:38:42 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 04/10] ksm: the mm interface to ksm
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-5-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> This patch presents the mm interface to a dummy version of ksm.c,
> for better scrutiny of that interface: the real ksm.c follows later.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
