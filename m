Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab0CNBOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 20:14:14 -0500
Received: from claw.goop.org ([74.207.240.146]:47295 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab0CNBON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 20:14:13 -0500
Message-ID: <4B9C3863.8060706@goop.org>
Date: Sat, 13 Mar 2010 17:14:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: "hrtimer: Tune hrtimer_interrupt hang logic" candidate for stable?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think "hrtimer: Tune hrtimer_interrupt hang logic" 
(41d2e494937715d3150e5c75d01f0e75ae899337) is a good candidate for 
stable 2.6.32.  We're seeing several reports against Xen kernels which 
look like the would be helped by this change.

Thanks,
     J
