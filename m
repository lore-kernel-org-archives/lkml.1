Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXAZIaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXAZIaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 03:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030816AbXAZIaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 03:30:13 -0500
Received: from contrabass.post.ru ([85.21.78.5]:59387 "EHLO contrabass.post.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030811AbXAZIaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 03:30:12 -0500
X-Greylist: delayed 1312 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 03:30:11 EST
Message-ID: <45B9B6D6.2080009@kernelpanic.ru>
Date: Fri, 26 Jan 2007 11:07:50 +0300
From: "Boris B. Zhmurov" <bb@kernelpanic.ru>
Reply-To: bb@kernelpanic.ru
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061220 Red Hat/1.0.7-0.1.el4 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: what kernel version embeds r1000 (RTL8168 Eth NICs)
References: <1169689006.26353.23.camel@asus.rktmb.org> <20070125093653.GA3070@strauss.suse.de>
In-Reply-To: <20070125093653.GA3070@strauss.suse.de>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bernhard Walle.

On 25.01.2007 12:36 you said the following:

> * Mihamina Rakotomandimby (R12y) <mihamina.rakotomandimby@etu.univ-orleans.fr> [2007-01-25 02:36]:
>> Hello,
>> I would like to know what version of the kernel will||had embed(ed) the
>> r1000 driver.
> 
> The r8169 driver which is in the kernel should have the same
> functionality.


No, it shouldn't and it hasn't. RTL8168 and RTL8167 support was added in
2.6.19.


-- 
	boris

