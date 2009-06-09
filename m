Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZFIEYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZFIEYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZFIEYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:24:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52095 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFIEYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:24:02 -0400
Message-ID: <4A2DE381.6090205@cn.fujitsu.com>
Date: Tue, 09 Jun 2009 12:22:25 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [RFC] IO scheduler based IO controller V4
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi All,
> 
> Here is the V4 of the IO controller patches generated on top of 2.6.30-rc8.
> 

Hi Vivek,

I can't apply the patchset.

[root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/1.eml
Applying io-controller: Documentation
[root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/2.eml
Applying io-controller: Common flat fair queuing code in elevaotor layer
error: patch failed: block/Makefile:15
error: block/Makefile: patch does not apply
Patch failed at 0001.
When you have resolved this problem run "git-am --resolved".
If you would prefer to skip this patch, instead run "git-am --skip".

