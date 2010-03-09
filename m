Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0CICva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:51:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0CICv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:51:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=2o6sa94q4GRDDrtDDxMA:9 a=QAmWeAJ89Eq68Ky4VhFbjfGCBbIA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2375c9f91003081840w5419d847q8ffd8b6ce46d86fb@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <2375c9f91003071831x4104dd8dp82967c0409391bd5@mail.gmail.com>
	 <2375c9f91003081840w5419d847q8ffd8b6ce46d86fb@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 21:51:25 -0500
Message-ID: <1268103085.10871.1862.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 10:40 +0800, Américo Wang wrote:

> > I will try this now.
> >
> 
> Unfortunately, this doesn't help.
> 
> What is worse, I got another soft lockup, although I already turned LOCKDEP off.

Hmm, this really sounds like somethings badly broken.

What version of GCC are you using?

-- Steve


