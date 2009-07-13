Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZGMUry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZGMUry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbZGMUry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:47:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZGMUry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:47:54 -0400
Message-ID: <4A5B9D52.3050703@redhat.com>
Date: Mon, 13 Jul 2009 16:47:14 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 0/4] OOM analysis helper patch series v3
References: <20090713144924.6257.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090713144924.6257.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> ChangeLog
>  Since v2
>    - Dropped "[4/5] add isolate pages vmstat" temporary because it become
>      slightly big. Then, I plan to submit it as another patchset.

Shame, I really liked that patch :)

-- 
All rights reversed.
