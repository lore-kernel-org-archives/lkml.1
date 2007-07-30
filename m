Return-Path: <linux-kernel-owner+w=401wt.eu-S968652AbXG3Vpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968652AbXG3Vpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967692AbXG3Vpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:45:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:43578 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967626AbXG3Vph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:45:37 -0400
In-Reply-To: <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org> <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com> <20070728034719.GA24448@joejin-pc.cn.oracle.com> <20070730135316.2ce21b28.akpm@linux-foundation.org> <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Jin <joe.jin@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, lkml <linux-kernel@vger.kernel.org>,
       wen.gang.wang@oracle.com
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Date: Mon, 30 Jul 2007 14:45:17 -0700
To: Badari Pulavarty <pbadari@us.ibm.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I am also taking a look at it right now.

Are we having a race to write a little test app that reproduces the  
problem? :)

- z
