Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0BKQFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:05:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60607 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0BKQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:05:05 -0500
To: Greg KH <gregkh@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH] sysfs: sysfs_sd_setattr set iattrs unconditionally
References: <20100120131602.12aa48f7@hyperion.delvare>
	<m1ocko6fkx.fsf@fess.ebiederm.org>
	<20100120160008.7d59688b@hyperion.delvare>
	<20100122041913.GC4302@suse.de>
	<20100203091138.1ababf5e@hyperion.delvare>
	<20100203142218.GA27676@suse.de> <m1hbpxlbhn.fsf_-_@fess.ebiederm.org>
	<m1tytn23ee.fsf@fess.ebiederm.org> <20100211155204.GB24191@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 08:05:00 -0800
In-Reply-To: <20100211155204.GB24191@suse.de> (Greg KH's message of "Thu\, 11 Feb 2010 07\:52\:04 -0800")
Message-ID: <m1ljez21xv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, Feb 11, 2010 at 07:33:29AM -0800, Eric W. Biederman wrote:
>> 
>> Greg I think this patch has slipped through the cracks.
>> Do I need to resend this regression fix or send it directly to Linus?
>> 
>> chmod and friends have been broken on sysfs since 2.6.32...
>
> Sorry, I was travelling last week, it's still in my queue, I'll get it
> to Linus soon.

That is a better excuse than my nasty cold.  Thanks for taking care of
this.

Eric
