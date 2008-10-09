Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYJILYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYJILYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbYJILYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:24:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbYJILYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:24:30 -0400
Message-ID: <48EDE9DD.208@redhat.com>
Date: Thu, 09 Oct 2008 07:24:13 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [mmotm 02/Oct PATCH 2/3] adjust hugepage related field of /proc/meminfo
References: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081009153854.DECD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081009153854.DECD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> adjust hugepage related field in /proc/meminfo.
> (because vmscan-split-lru-lists-into-anon-file-sets.patch changed
> length of other field)

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
