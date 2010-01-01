Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031Ab0AAPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0AAPAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967Ab0AAPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:00:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0AAPAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:00:30 -0500
Message-ID: <4B3E0DE0.8040009@redhat.com>
Date: Fri, 01 Jan 2010 09:59:44 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/4] vmstat: add anon_scan_ratio field to zoneinfo
References: <20091228164451.A687.A69D9226@jp.fujitsu.com> <20091228164816.A68D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091228164816.A68D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2009 02:48 AM, KOSAKI Motohiro wrote:
> Vmscan folks was asked "why does my system makes so much swap-out?"
> in lkml at several times.
> At that time, I made the debug patch to show recent_anon_{scanned/rorated}
> parameter at least three times.
>
> Thus, its parameter should be showed on /proc/zoneinfo. It help
> vmscan folks debugging.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
