Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbXCEMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbXCEMb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXCEMb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:31:27 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:33676 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbXCEMb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:31:27 -0500
Date: Mon, 5 Mar 2007 13:31:06 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <382470.25191.qm@web52508.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0703051328240.23714@yvahk01.tjqt.qr>
References: <382470.25191.qm@web52508.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 4 2007 19:37, Marc Perkel wrote:
>> 
>>   -b internal -- seems like a good idea to speed up
>>   resynchronization.
>
>I'm trying to figure out what the default is. 

-b none, meaning the whole drive will be resynchronized when the
even counters don't match.

http://gentoo-wiki.com/HOWTO_Install_on_Software_RAID#Write-intent_bitmap


Jan
-- 
