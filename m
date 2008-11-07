Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYKGNXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYKGNXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYKGNXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:23:43 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:58213 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKGNXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uaDNp6QJPOaVVc4RwVd1gJ13BCMbZ5R5J4SyQtcjTXYbBe02bGPJu+r+TVefi8ROqm
         Rr4ZBerryul1woO6uDypGQsi0WQze2RRIsIiLbZ8pmXncZjEqQZnDWkbejgzG9S/OqC9
         0Fiw4X0THl0ciSLOlhralsGBHH7VWPLZdaEFs=
Message-ID: <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com>
Date: Fri, 7 Nov 2008 21:23:41 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Cyril Hrubis" <metan@ucw.cz>
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Cc: "Pavel Machek" <pavel@suse.cz>, Dmitry <dbaryshkov@gmail.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com
In-Reply-To: <20081106191424.GA2273@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz>
	 <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com>
	 <20081105173303.GC2038@elf.ucw.cz>
	 <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com>
	 <20081106080416.GA1531@ucw.cz>
	 <20081106191424.GA2273@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
Did you guys ever try that?

On Fri, Nov 7, 2008 at 3:14 AM, Cyril Hrubis <metan@ucw.cz> wrote:
> Hi,
>> I do not have serial cable :-(,
>
> Okay I have one that works for sl5500, it needs external power on
> sl-cxxx but it should be easy to fix.
>
> --
> metan
>
