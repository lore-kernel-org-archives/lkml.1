Return-Path: <linux-kernel-owner+w=401wt.eu-S967264AbXG3V5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967264AbXG3V5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939307AbXG3V46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:56:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45740 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938298AbXG3V45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:56:57 -0400
Subject: Re: [PATCH] add check do_direct_IO() return val
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
In-Reply-To: <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
	 <20070726221307.3d7b3446.akpm@linux-foundation.org>
	 <20070727071547.GA25084@joejin-pc.cn.oracle.com>
	 <46A9E6F9.20603@oracle.com>
	 <20070728034719.GA24448@joejin-pc.cn.oracle.com>
	 <20070730135316.2ce21b28.akpm@linux-foundation.org>
	 <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
	 <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 14:58:58 -0700
Message-Id: <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 14:45 -0700, Zach Brown wrote:
> > I am also taking a look at it right now.
> 
> Are we having a race to write a little test app that reproduces the  
> problem? :)

Nope. Feel free to write the test case. I am just looking at the code
to see what needs to be done.

Thanks,
Badari

