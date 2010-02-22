Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0BVU2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:28:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0BVU2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:28:39 -0500
Message-ID: <4B82E8B7.4050100@redhat.com>
Date: Mon, 22 Feb 2010 15:27:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] vmscan: factor out page reference checks
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <1266868150-25984-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1266868150-25984-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 02:49 PM, Johannes Weiner wrote:
> Moving the big conditional into its own predicate function makes the
> code a bit easier to read and allows for better commenting on the
> checks one-by-one.
>
> This is just cleaning up, no semantics should have been changed.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>
