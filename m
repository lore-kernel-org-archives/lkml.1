Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYKKIw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYKKIw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYKKIwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:52:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65255 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbYKKIws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:52:48 -0500
Message-ID: <49194739.7000100@cn.fujitsu.com>
Date: Tue, 11 Nov 2008 16:50:01 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 3/4] io controller: Core IO controller implementation
 logic
References: <20081106153022.215696930@redhat.com> <20081106153135.869625751@redhat.com>
In-Reply-To: <20081106153135.869625751@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vgoyal@redhat.com wrote:

Hi vivek,

I think bio_group_controller() need to be exported by EXPORT_SYMBOL()

-- 
Regards
Gui Jianfeng

