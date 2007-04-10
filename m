Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbXDJHvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbXDJHvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXDJHvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:51:35 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:57970 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXDJHve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:51:34 -0400
Date: Tue, 10 Apr 2007 03:51:33 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <20070410071217.GA28899@aepfle.de>
To: linux-kernel@vger.kernel.org
Cc: Olaf Hering <olaf@aepfle.de>, Dave Dillow <dave@thedillows.org>,
       Dave Jones <davej@redhat.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704100351.33699.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <1176169246.3193.2.camel@obelisk.thedillows.org>
 <20070410071217.GA28899@aepfle.de>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007, Olaf Hering wrote:
>On Mon, Apr 09, Dave Dillow wrote:
>> It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
>> saves the device and inode numbers from the {,l}stat() call on each
>> file and decides it is a new file if either number changes from run to
>> run.
>
>So fix tar to not do silly things.
>Kernel major:minor numbers are not stable.

YOU Tell that to the tar/star people, they are flabbergasted that its not 
stable.  It apparently is for every other OS tar can be run on.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
All your people must learn before you can reach for the stars.
		-- Kirk, "The Gamesters of Triskelion", stardate 3259.2
