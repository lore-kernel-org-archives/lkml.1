Return-Path: <linux-kernel-owner+w=401wt.eu-S965281AbXA3JHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965281AbXA3JHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXA3JHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:07:41 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:52590 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965389AbXA3JHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:07:40 -0500
Date: Tue, 30 Jan 2007 10:07:12 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: pradeep <pradeep.sawlani@celunite.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Multiple ip= boot arguments?
In-Reply-To: <45BE73C8.5010005@celunite.com>
Message-ID: <Pine.LNX.4.61.0701301005420.23321@yvahk01.tjqt.qr>
References: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com>
 <Pine.LNX.4.61.0701292146470.5077@yvahk01.tjqt.qr> <45BE73C8.5010005@celunite.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2007 03:53, pradeep wrote:
> Jan Engelhardt wrote:
>> On Jan 29 2007 12:36, Kevin Nicoll wrote:
>> 
>> > or if I'm supposed to use a startup script instead.
>> 
>> This is the preffered way nowadays. One day, hopefully,
>> CONFIG_IP_PNP can go away.
>> 
> CONFIG_IP_PNP is required while mounting rootfs on NFS.

It is definitely not.


	-`J'
-- 
