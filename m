Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZEUHnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZEUHnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZEUHnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:43:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:51497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbZEUHm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:42:59 -0400
Message-ID: <4A1505FA.3080507@kernel.org>
Date: Thu, 21 May 2009 16:42:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 12/20] sysfs: Nicely indent sysfs_symlink_inode_operations
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com> <1242865694-2100-8-git-send-email-ebiederm@xmission.com> <1242865694-2100-9-git-send-email-ebiederm@xmission.com> <1242865694-2100-10-git-send-email-ebiederm@xmission.com> <1242865694-2100-11-git-send-email-ebiederm@xmission.com> <1242865694-2100-12-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-12-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 07:42:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Lining up the functions in sysfs_symlink_inode_operations
> follows the pattern in the rest of sysfs and makes things
> slightly more readable.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
