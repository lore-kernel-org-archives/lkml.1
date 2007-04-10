Return-Path: <linux-kernel-owner+w=401wt.eu-S1031013AbXDJQTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031013AbXDJQTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031021AbXDJQTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:19:49 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49932 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031013AbXDJQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:19:48 -0400
Date: Tue, 10 Apr 2007 18:14:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <200704100351.33699.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.61.0704101809440.21664@yvahk01.tjqt.qr>
References: <200704091007.58535.gene.heskett@gmail.com>
 <1176169246.3193.2.camel@obelisk.thedillows.org> <20070410071217.GA28899@aepfle.de>
 <200704100351.33699.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 03:51, Gene Heskett wrote:
>On Tuesday 10 April 2007, Olaf Hering wrote:
>>On Mon, Apr 09, Dave Dillow wrote:
>>> It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
>>> saves the device and inode numbers from the {,l}stat() call on each
>>> file and decides it is a new file if either number changes from run to
>>> run.
>>
>>So fix tar to not do silly things.
>>Kernel major:minor numbers are not stable.
>
>YOU Tell that to the tar/star people, they are flabbergasted that its not 
>stable.  It apparently is for every other OS tar can be run on.

FreeBSD also seems to be quite "dynamic".
/dev/da0 is (0,92) for the 'fixit shell' -- how about you?


Jan
-- 
