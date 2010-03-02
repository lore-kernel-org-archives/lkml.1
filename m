Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0CBTRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 14:17:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0CBTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 14:17:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=5NVHotgoJoIA:10 a=7U3hwN5JcxgA:10 a=JxY7tLwbamfrbw2YqUEA:9 a=c2UABteAHuzy2VFA1Zc3H_EO7Z8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [GIT PULL] single block IO revert (Was "Re: Oops while booting
 2.6.34-rc0 (block pull busted)")
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org,
       Michael Breuer <mbreuer@majjas.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, dmonakhov@openvz.org
In-Reply-To: <20100302182117.GW5768@kernel.dk>
References: <201003011615.31709.dmitry.torokhov@gmail.com>
	 <20100302075656.GO5768@kernel.dk> <20100302081547.GP5768@kernel.dk>
	 <hmiocs$p6h$1@dough.gmane.org> <4B8D41C7.1030404@majjas.com>
	 <20100302174250.GA13131@goodmis.org> <20100302174939.GB13131@goodmis.org>
	 <20100302182117.GW5768@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 02 Mar 2010 14:17:02 -0500
Message-ID: <1267557422.10871.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 19:21 +0100, Jens Axboe wrote:
> On Tue, Mar 02 2010, Steven Rostedt wrote:

> 
> We'll revert it asap, no point in wasting time debugging it first.

Thanks!

Since I have a box that triggers this issue, let me know if there's a
git branch you would like me to test.

-- Steve


