Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZHGBgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZHGBgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZHGBgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:36:40 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:50653 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZHGBgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:36:40 -0400
Date: Fri, 07 Aug 2009 10:36:40 +0900 (JST)
Message-Id: <20090807.103640.104065157.ryov@valinux.co.jp>
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH] dm-ioband-v1.12.3: I/O bandwidth controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090731.130333.104034609.ryov@valinux.co.jp>
References: <20090731.130333.104034609.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair,

Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> Hi Alasdair,
> 
> This is dm-ioband v1.12.3 release that is a minor update to avoid
> sparse warnings other than related to the event tracing. (I used
> sparse-2009-07-29.)
> 
> This patch can be applied to the current dm-devel tree and 2.6.31-rc4,
> so could you please replace dm-add-ioband.patch in your tree with this?
> And I would appreciate it if you would let me know your thoughts about
> merging dm-ioband to upstream.

The dm-ioband patch in the dm-devel tree is still older. Could you
please update it with the new patch? And could you please let me know
your thoughts about dm-ioband?

Thanks,
Ryo Tsuruta
