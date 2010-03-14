Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab0CNVU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 17:20:28 -0400
Received: from lo.gmane.org ([80.91.229.12]:35328 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab0CNVU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 17:20:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
Date: Sun, 14 Mar 2010 17:20:13 -0400
Message-ID: <hnjjud$k26$1@dough.gmane.org>
References: <20100314075831.GA13457@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-149-162.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
In-Reply-To: <20100314075831.GA13457@elf.ucw.cz>
Cc: alsa-devel@alsa-project.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
> thinkpad and geode notebook).
> 
> On 2.6.34-rc1, hit ^Z and sound starts looping.
> 									Pavel
That's not new, I have seen it back as far as 2.6.27.25 doing a suspend in a VM 
(KVM, no libvirt). But it only happens a few times a year, so I never chased it. 
I hate to report an occasional problem in an obsolete kernel, and I can't 
reproduce it.

Does it happen repeatably with the new kernel?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

