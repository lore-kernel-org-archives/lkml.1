Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0BKPw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:52:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:50300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab0BKPwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:52:24 -0500
Date: Thu, 11 Feb 2010 07:52:04 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH] sysfs: sysfs_sd_setattr set iattrs unconditionally
Message-ID: <20100211155204.GB24191@suse.de>
References: <20100120131602.12aa48f7@hyperion.delvare>
 <m1ocko6fkx.fsf@fess.ebiederm.org>
 <20100120160008.7d59688b@hyperion.delvare>
 <20100122041913.GC4302@suse.de>
 <20100203091138.1ababf5e@hyperion.delvare>
 <20100203142218.GA27676@suse.de>
 <m1hbpxlbhn.fsf_-_@fess.ebiederm.org>
 <m1tytn23ee.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tytn23ee.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 07:33:29AM -0800, Eric W. Biederman wrote:
> 
> Greg I think this patch has slipped through the cracks.
> Do I need to resend this regression fix or send it directly to Linus?
> 
> chmod and friends have been broken on sysfs since 2.6.32...

Sorry, I was travelling last week, it's still in my queue, I'll get it
to Linus soon.

thanks,

greg k-h
