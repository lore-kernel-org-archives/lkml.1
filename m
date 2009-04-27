Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZD0KaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZD0KaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZD0KaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:30:07 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48825 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752136AbZD0KaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:30:06 -0400
Date: Mon, 27 Apr 2009 19:30:06 +0900 (JST)
Message-Id: <20090427.193006.112614137.ryov@valinux.co.jp>
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, vgoyal@redhat.com, fernando@oss.ntt.co.jp,
       linux-kernel@vger.kernel.org, jmoyer@redhat.com, jens.axboe@oracle.com,
       nauman@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com
Subject: Re: dm-ioband: Test results.
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090422151805.GC32602@redhat.com>
References: <20090421141607.GA22619@redhat.com>
	<20090422.121443.104042516.ryov@valinux.co.jp>
	<20090422151805.GC32602@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> Why is it that you repeatedly ignore concern/discussion about your
> determination to continue using a custom grouping mechanism?  It is this
> type of excess layering that serves no purpose other than to facilitate
> out-of-tree use-cases.  dm-ioband would take a big step closer to being
> merged upstream if you took others' feedback and showed more willingness
> to work through the outstanding issues.

I think dm-ioband's approach is one simple way to handle cgroup
because the current cgroup has no way to manage kernel module's
resources. Please tell me if you have any good ideas to handle 
cgroup by dm-ioband.

Thanks,
Ryo Tsuruta
