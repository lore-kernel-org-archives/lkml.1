Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbZLaJFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbZLaJFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZLaJFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:05:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43141 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZLaJFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:05:23 -0500
Message-ID: <4B3C6942.3020204@cs.helsinki.fi>
Date: Thu, 31 Dec 2009 11:05:06 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] [mmotm v2] ramzswap: add handlers for various swap
 events
References: <1262232518-2841-1-git-send-email-ngupta@vflare.org> <1262232518-2841-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1262232518-2841-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> The SWAPON handler sets callback which frees memory associated
> with given swap slot, eliminating any stale data in corresponding
> ramzswap device.

I guess this changelog is too terse and should explain _why_ we want 
this in more detail.

			Pekka
