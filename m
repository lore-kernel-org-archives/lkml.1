Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbZJIUfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbZJIUfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZJIUfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbZJIUfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:35:09 -0400
Message-ID: <4ACF9E5B.9060205@redhat.com>
Date: Fri, 09 Oct 2009 16:34:35 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] vmscan: kill shrink_all_zones()
References: <20091009174756.12B5.A69D9226@jp.fujitsu.com> <20091009175559.12B8.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091009175559.12B8.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> At that time, their patch was pretty worth. However, Modern Hardware
> trend and recent VM improvement broke its worth. From several reason,
> I think we should remove shrink_all_zones() at all.

> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
