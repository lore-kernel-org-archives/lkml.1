Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZI2V6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZI2V6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZI2V6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:58:24 -0400
Received: from smtp181.iad.emailsrvr.com ([207.97.245.181]:53139 "EHLO
	smtp181.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZI2V6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:58:23 -0400
Message-ID: <4AC28302.1060305@librato.com>
Date: Tue, 29 Sep 2009 17:58:26 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
References: <20090924165548.GA16586@us.ibm.com>	<20090924170308.GH16989@us.ibm.com>	<200909242343.59903.arnd@arndb.de>	<20090925082346.GB4436@localdomain>	<20090925105632.GG12824@hawkmoon.kerlabs.com> <20090929180537.GD4625@us.ibm.com>
In-Reply-To: <20090929180537.GD4625@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> Ccing kosaki.motohiro@jp.fujitsu.com and linux-api on this thread.
> 
> Louis Rilling [Louis.Rilling@kerlabs.com] wrote:
> | > It will very likely break ia64, which defines CONFIG_HAVE_ARCH_TRACEHOOK and
> | > already has sys_clone2().
> | 
> | -> sys_clone_ext() ?
> | 
> | Louis
> 
> How about spelling out extended and calling it clone_extended() ?
> 
> The other options I can think of are clone_with_pids() and clone3().

I like clone3(), or clone_new() ?

or even better -- how about xerox()  :p

Oren.

