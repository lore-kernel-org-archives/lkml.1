Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbZEMOqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbZEMOqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbZEMOpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:45:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41984 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZEMOpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:45:38 -0400
Message-ID: <4A0ADC9D.5080906@redhat.com>
Date: Wed, 13 May 2009 10:43:41 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 3/4] vmscan: zone_reclaim use may_swap
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120651.5882.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090513120651.5882.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] vmscan: zone_reclaim use may_swap

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
