Return-Path: <linux-kernel-owner+w=401wt.eu-S966246AbXDDBhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966246AbXDDBhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966264AbXDDBhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:37:00 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:63996 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S966246AbXDDBgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:36:36 -0400
Date: Tue, 3 Apr 2007 18:07:06 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070404022828.5c9b97f3@the-village.bc.nu>
Message-ID: <Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
References: <1175644642.10567.31.camel@shinybook.infradead.org><200704032210
 02.GA13210@cynthia.pants.nu><1175648051.10567.61.camel@shinybook.infradead.
 org><20070403.181645.68159458.davem@davemloft.net> <20070404022828.5c9b97f3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Alan Cox wrote:

>> I don't need to know anything about the inanrds of my computer to
>> bring up the ethernet interface, me caveman me bringup eth0, me on
>> network, caveman happy.  The same should be true for serial ports.
>
> You don't get machines with 64 ethernet ports on add-in cards. There are
> good reasons for the naming schemes in use.

I've seen machines offering up to 48, what's the magic number that makes you 
need to chagne nameing schemes?

I also know of systems with 50 serial ports on them. the fact that some of the 
serial ports on the front panel were named differently then other serial ports 
on the front panel sure didn't make my life easier in dealing with them.

David Lang
