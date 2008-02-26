Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYBZHum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYBZHum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbYBZHu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:50:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbYBZHu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:50:28 -0500
Message-ID: <47C3C462.4000706@cn.fujitsu.com>
Date: Tue, 26 Feb 2008 15:48:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] CGroup API files: Various cleanup to CGroup control
 files
References: <20080223224725.115590000@menage.corp.google.com>	 <47C3862D.8080603@cn.fujitsu.com> <6599ad830802252219p77f41917u7c6c137c8e5448e0@mail.gmail.com>
In-Reply-To: <6599ad830802252219p77f41917u7c6c137c8e5448e0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Feb 25, 2008 at 7:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>  Should those pathces be rebased againt 2.6.25-rc3 ?
>>
> 
> No, because they're against 2.6.25-rc2-mm1, which is already has (I
> think) any of the new bits in 2.6.25-rc3 that would be affected by
> these patches.
> 
> Paul

-rc2-mm1 came out on 2008-02-16, but the patches I posted several days ago
has been merged into -rc3, so your patches don't apply now. :(

Think about ./MAINTAINERS update and set up a git tree for development of
cgroup and cgroup subsystems as Andrew suggested. :)
