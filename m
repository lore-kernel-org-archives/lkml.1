Return-Path: <linux-kernel-owner+w=401wt.eu-S1030772AbXAZGNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030772AbXAZGNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXAZGNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:13:48 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:56743 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030772AbXAZGNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:13:47 -0500
Message-ID: <45B99C19.9010703@kernel.org>
Date: Thu, 25 Jan 2007 22:13:45 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 1/2] RCU priority boosting that survives semi-vicious
 testing
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <45B87873.3080207@freedesktop.org> <20070125195816.GH1705@linux.vnet.ibm.com> <20070126014711.GA28014@linux.vnet.ibm.com>
In-Reply-To: <20070126014711.GA28014@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Jan 25, 2007 at 11:58:16AM -0800, Paul E. McKenney wrote:
>> On Thu, Jan 25, 2007 at 01:29:23AM -0800, Josh Triplett wrote:
>>> Overall, this code looks sensible to me.  Some comments on the patch below.
> 
> [ . . . ]
> 
>> Thank you again for the careful and thorough review!!!
>>
>> I will test these changes and send out an update.
>
> And here is the updated RCU priority-boost patch.

Thanks for integrating my changes, and so quickly! :)

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Josh Triplett <josh@kernel.org>

- Josh Triplett
