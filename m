Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZF2NNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZF2NNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZF2NNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:13:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:33371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZF2NNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="159581684"
Date: Mon, 29 Jun 2009 21:13:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Ronald Moesbergen <intercommit@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090629131326.GA23668@localhost>
References: <20090606233056.7B9F.A69D9226@jp.fujitsu.com> <20090606224538.GA6173@localhost> <20090618120436.ad3196e3.akpm@linux-foundation.org> <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net> <20090629093423.GB1315@localhost> <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com> <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A48BBF9.6050408@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:04:57PM +0800, Vladislav Bolkhovitin wrote:
> Wu Fengguang, on 06/29/2009 04:54 PM wrote:
> > 
> > Why not 2.6.30? :)
> 
> We started with 2.6.29, so why not complete with it (to save additional 
> Ronald's effort to move on 2.6.30)?

OK, that's fair enough.

Fengguang
