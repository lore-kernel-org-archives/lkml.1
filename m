Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbZLQJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbZLQJbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764189AbZLQJbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:31:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1764153AbZLQJbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:31:16 -0500
Message-ID: <4B29F957.3090404@cn.fujitsu.com>
Date: Thu, 17 Dec 2009 17:26:47 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 2/4] cfq-iosched: Get rid of nr_groups
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <1261003980-10115-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1261003980-10115-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o Currently code does not seem to be using cfqd->nr_groups. Get rid of it.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

