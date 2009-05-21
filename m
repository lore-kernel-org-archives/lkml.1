Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZEUBta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZEUBta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZEUBtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:36238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZEUBtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:49:20 -0400
Message-ID: <4A14B313.8030700@kernel.org>
Date: Thu, 21 May 2009 10:49:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 01:49:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Because of rename ordering problems we occassionally give false
> warnings about invalid sysfs operations, so implement a helper
> function for this common sysfs idiom.
> 
> This is a stripped down version of an earlier patch that
> also added sysfs_delete_link.
> 
> Cc: Benjamin Thery <benjamin.thery@bull.net>
> Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

I think this has been brought up before but can you please use
--no-chain-reply-to?  It's painful to follow the deep nesting.

Thanks.

-- 
tejun
