Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZGIXbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZGIXbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZGIXbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:31:02 -0400
Received: from mail.vyatta.com ([76.74.103.46]:40171 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZGIXbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:31:01 -0400
Date: Thu, 9 Jul 2009 16:30:55 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Clock incorrect on 2.6.31-rc2
Message-ID: <20090709163055.115d5878@nehalam>
In-Reply-To: <1247181779.3259.6.camel@work-vm>
References: <20090709141000.584d199a@nehalam>
	<1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
	<20090709153855.6230729e@nehalam>
	<1247181779.3259.6.camel@work-vm>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I'm a little stumped.  Does the problem occur on every reboot? How long
> does the box need to be up before you see an issue?  Or does it go away
> after a little while?

It seemed to take a while (several hours). I will leave it running overnight

