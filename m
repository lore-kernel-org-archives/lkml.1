Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXDMTg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXDMTg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXDMTg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:36:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbXDMTg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:36:26 -0400
Message-ID: <461FDBB4.8070208@redhat.com>
Date: Fri, 13 Apr 2007 15:36:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com> <Pine.LNX.4.61.0704112347230.20436@yvahk01.tjqt.qr> <461D5C24.9080506@redhat.com> <200704132142.29582.bzolnier@gmail.com>
In-Reply-To: <200704132142.29582.bzolnier@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
>> Now we're getting somewhere. There is some other OS on here because
>> it's required for doing BIOS updates. I booted it and shut down.
>> The power cycle count increased but the power off retract count did not.
>>
>> The counts are:
>>
>> power cycle ... 111
>> power off retract ... 92
>>
>> The difference is now 19; it was 18 before.
> 
> Is the noise present if you reboot the other OS?
> Does it result in Power-Off_Retract count increase?

There is no noise and the retract count does not increase when I boot
and then shutdown/power off the other OS.

