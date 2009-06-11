Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZFKQHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZFKQHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZFKQHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:07:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33512 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZFKQHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:07:36 -0400
Message-ID: <4A312B9F.4010208@redhat.com>
Date: Thu, 11 Jun 2009 12:06:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] HWPOISON: remove early kill option for now
References: <20090611142239.192891591@intel.com> <20090611144430.682162784@intel.com>
In-Reply-To: <20090611144430.682162784@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> It needs more thoughts, and is not a must have for .31.
> 
> CC: Nick Piggin <npiggin@suse.de>
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Fair enough.  It's not an absolute must-have and still needs
a little bit more work.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
