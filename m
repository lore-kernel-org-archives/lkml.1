Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0CCBaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:30:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:44372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0CCBaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:30:52 -0500
Message-ID: <4B8DBE67.5070302@kernel.org>
Date: Wed, 03 Mar 2010 10:41:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 45/62] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init
 on dynamic attributes
References: <20100302230933.GA32287@kroah.com> <1267572541-410-45-git-send-email-gregkh@suse.de>
In-Reply-To: <1267572541-410-45-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 01:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 08:28 AM, Greg Kroah-Hartman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> These are the non-static sysfs attributes that exist on
> my test machine.  Fix them to use sysfs_attr_init or
> sysfs_bin_attr_init as appropriate.   It simply requires
> making a sysfs attribute present to see this.  So this
> is a little bit tedious but otherwise not too bad.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
