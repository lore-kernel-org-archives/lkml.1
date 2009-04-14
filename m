Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZDNOo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZDNOo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZDNOos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:44:48 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:46760 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZDNOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:44:48 -0400
Message-ID: <49E4A157.4090903@wpkg.org>
Date: Tue, 14 Apr 2009 16:44:39 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fast testing
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 4/14/09, Dragoslav Zaric <dragoslav.zaric.kd@gmail.com> wrote:
>> Hello,
>>
>> I have question regarding fast testing of some change in some kernel
>> source file. Since rebooting is a long process,

Use kexec to "reboot" faster.


> there must be way to
>> test some change faster [of course only if source file is not some boot
>> connected file, but maybe this is also doable].

Compile the things you want to test as modules, if possible.


-- 
Tomasz Chmielewski
http://wpkg.org

