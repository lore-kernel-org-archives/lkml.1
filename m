Return-Path: <linux-kernel-owner+w=401wt.eu-S1030777AbXDKDya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030777AbXDKDya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXDKDya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:54:30 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:42619 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030779AbXDKDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:54:28 -0400
Date: Tue, 10 Apr 2007 23:54:22 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <Pine.LNX.4.61.0704101809440.21664@yvahk01.tjqt.qr>
To: linux-kernel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704102354.23766.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704100351.33699.gene.heskett@gmail.com>
 <Pine.LNX.4.61.0704101809440.21664@yvahk01.tjqt.qr>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007, Jan Engelhardt wrote:
>On Apr 10 2007 03:51, Gene Heskett wrote:
>>On Tuesday 10 April 2007, Olaf Hering wrote:
>>>On Mon, Apr 09, Dave Dillow wrote:
>>>> It's not /dev he's backing up -- its /home, /usr, and others. GNU
>>>> tar saves the device and inode numbers from the {,l}stat() call on
>>>> each file and decides it is a new file if either number changes from
>>>> run to run.
>>>
>>>So fix tar to not do silly things.
>>>Kernel major:minor numbers are not stable.
>>
>>YOU Tell that to the tar/star people, they are flabbergasted that its
>> not stable.  It apparently is for every other OS tar can be run on.
>
>FreeBSD also seems to be quite "dynamic".
>/dev/da0 is (0,92) for the 'fixit shell' -- how about you?
>
I don't have such a beast here.  Whats that supposed to do?
>
>Jan



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Life sucks, but death doesn't put out at all.
		-- Thomas J. Kopp
