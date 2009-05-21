Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZEUGYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZEUGYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZEUGYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:24:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:59503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZEUGYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:24:37 -0400
Message-ID: <4A14F38F.2090203@kernel.org>
Date: Thu, 21 May 2009 15:24:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 05/20] sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 06:24:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Using dentry instead of d in the function name is what
> several other filesystems are doing and it seems to be
> a more readable convention.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
