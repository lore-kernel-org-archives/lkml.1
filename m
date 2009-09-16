Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZIPMIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZIPMIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbZIPMIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:08:34 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:34890 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712AbZIPMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:08:31 -0400
Date: Wed, 16 Sep 2009 21:08:35 +0900 (JST)
Message-Id: <20090916.210835.104036814.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: nauman@google.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, riel@redhat.com
Subject: Re: ioband: Writer starves reader even without competitors
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090915233706.GA3770@redhat.com>
References: <4AA68AA5.10505@redhat.com>
	<20090908175400.GE15974@redhat.com>
	<20090915233706.GA3770@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Ryo,
> 
> I notice that with-in a single ioband device, a single writer starves the
> reader even without any competitor groups being present.
> 
> I ran following two tests with and without dm-ioband devices

Thank you again for testing dm-ioband.
I got the similar results and am investigating it now.
I'll let you know if I find something.

Thanks,
Ryo Tsuruta
