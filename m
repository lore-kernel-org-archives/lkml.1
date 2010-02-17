Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0BQWDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:03:25 -0500
Received: from xenotime.net ([72.52.64.118]:55888 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751965Ab0BQWDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:03:24 -0500
Message-ID: <4B7C67A1.5070106@xenotime.net>
Date: Wed, 17 Feb 2010 14:03:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [Kgdb-bugreport] [PATCH 15/28] kgdb,	docs: Update the kgdb docs
 to include kdb
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com> <1266014143-29444-16-git-send-email-jason.wessel@windriver.com> <4B7705B4.5080009@xenotime.net> <4B7C5902.1030306@windriver.com>
In-Reply-To: <4B7C5902.1030306@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/10 13:00, Jason Wessel wrote:
> Randy Dunlap wrote:
>> On 02/12/10 14:35, Jason Wessel wrote:
>>> Update the kgdb docs to reflect the new directory structure and API.
>>>
>>> Merge in the kdb shell information.
>>
>> See comments/corrections inline below.
>>
> 
> Thank very much for the comments.  Would you like a credit in the
> manual?

not needed.

> I merged in all your edits.
> 
> Here is the interdiff in case you were curious.
> 
> Thanks,
> Jason.
> 
>  DocBook/kgdb.tmpl     |  208 ++++++++++++++++++++++++++++----------------------
>  kernel-parameters.txt |    3 
>  2 files changed, 118 insertions(+), 93 deletions(-)


thanks,
-- 
~Randy
