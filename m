Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331Ab0AYVaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0AYVaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272Ab0AYVaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:30:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43759
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab0AYVaM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:30:12 -0500
Date: Mon, 25 Jan 2010 13:30:24 -0800 (PST)
Message-Id: <20100125.133024.41664373.davem@davemloft.net>
To: rjw@sisk.pl
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, bonbons@linux-vserver.org,
       eric.dumazet@gmail.com
Subject: Re: [Bug #15137] NULL pointer dereference in vlan_skb_recv
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001252207.53023.rjw@sisk.pl>
References: <hE3x9c-4KZM.A.W0E.4JMXLB@chimera>
	<20100125134346.GA3749@hack>
	<201001252207.53023.rjw@sisk.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 25 Jan 2010 22:07:52 +0100

> On Monday 25 January 2010, Américo Wang wrote:
>> On Sun, Jan 24, 2010 at 11:04:41PM +0100, Rafael J. Wysocki wrote:
>> >This message has been generated automatically as a part of a report
>> >of recent regressions.
>> >
>> >The following bug entry is on the current list of known regressions
>> >from 2.6.32.  Please verify if it still should be listed and let me know
>> >(either way).
>> >
>> >
>> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15137
>> >Subject		: NULL pointer dereference in vlan_skb_recv
>> >Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
>> >Date		: 2010-01-23 15:56 (2 days old)
>> >References	: http://marc.info/?l=linux-kernel&m=126426286507497&w=4
>> >Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
>> >Patch		: http://patchwork.kernel.org/patch/74999/
>> >		  http://patchwork.kernel.org/patch/75002/
>> >
>> 
>> This one can be closed, patch from Eric is already applied by David Miller.
> 
> Is it in the Linus' tree already?

No, but it will be there soon, I'll push it to him today.
:-)
