Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191Ab0AEDXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0AEDXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0AEDXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:23:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0AEDXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:23:11 -0500
X-Authority-Analysis: v=1.0 c=1 a=8HD_1V-98IEA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=mySyxEvdcJ4hjBT1nwIA:9 a=_v1GwENqu9zw6-Dwbc8nrnC2eK0A:4 a=U62fhAwekXMA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/3] trace-view: Add trace-view python wrapper
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1262654682-20325-1-git-send-email-dvhltc@us.ibm.com>
References: <1262654682-20325-1-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 04 Jan 2010 22:23:09 -0500
Message-ID: <1262661789.28171.692.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 17:24 -0800, Darren Hart wrote:
> The following patch series wraps the C trace-view-store for use with Python.
> 
> Please pull the latest for-rostedt/trace-view git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/trace-cmd.git for-rostedt/trace-view
> 
> 
> (Apologies if this series arrives twice, I seem to be experiencing relay
> issues).

Thanks, but you never pushed this up to kernel.org. I've applied them on
a temp branch and they work after fixing some conflicts with commits I
made.

If you want, I can just push that back out, but that will require you to
do a rebase. But if I do another pull from you, I'll just have to
resolve the conflicts again.

-- Steve


