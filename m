Return-Path: <linux-kernel-owner+w=401wt.eu-S968939AbXG3V7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968939AbXG3V7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968399AbXG3V7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:59:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51095 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968379AbXG3V7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:59:14 -0400
In-Reply-To: <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com> <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com> <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <48D71811-FA3C-4896-838D-736EC2CD885D@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Date: Mon, 30 Jul 2007 14:58:58 -0700
To: Badari Pulavarty <pbadari@us.ibm.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 30, 2007, at 2:58 PM, Badari Pulavarty wrote:

> On Mon, 2007-07-30 at 14:45 -0700, Zach Brown wrote:
>>> I am also taking a look at it right now.
>>
>> Are we having a race to write a little test app that reproduces the
>> problem? :)
>
> Nope. Feel free to write the test case. I am just looking at the code
> to see what needs to be done.

OK, sounds good.

- z
