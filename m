Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYJILYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYJILYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYJILYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:24:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbYJILYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:24:07 -0400
Message-ID: <48EDE9BD.9070602@redhat.com>
Date: Thu, 09 Oct 2008 07:23:41 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [mmotm 02/Oct PATCH 1/3] adjust Quicklists field of /proc/meminfo
References: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081009153432.DEC7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> vmscan-split-lru-lists-into-anon-file-sets.patch changed /proc/meminfo output length,
> but only Quicklists: field doesn't.
> (because quicklists field added after than split-lru)

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
