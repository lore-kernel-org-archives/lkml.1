Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbYBRI05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbYBRI05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYBRI0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:26:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57375 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYBRI0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:26:49 -0500
Message-ID: <47B940EA.5000305@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 16:25:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/7] cgroup: fix and update documentation
References: <47B91C75.6000907@cn.fujitsu.com> <20080218010255.a808714f.pj@sgi.com>
In-Reply-To: <20080218010255.a808714f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Li Zefan wrote:
>>  *** notify_on_release is disabled in the current patch set. It will be
>> -*** reactivated in a future patch in a less-intrusive manner
>> +*** reactivated in a future patch in a less-intrusive manner.
> 
> Someone should verify this, but I'm pretty sure that notify_on_release
> is now working ... no longer disabled.  I believe the above line from
> the documentation is out of date.
> 

Aha, it does work now. I tried it but it didn't seem to work, maybe I didn't
something wrong. I'll resend a new patch.

