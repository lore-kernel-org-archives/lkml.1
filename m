Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYHTJNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYHTJNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYHTJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:13:37 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:37693 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYHTJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:13:36 -0400
Date: Wed, 20 Aug 2008 11:13:26 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20080820091326.GL21330@tekkaman>
References: <1219182612-13814-1-git-send-email-giometti@linux.it> <1219182612-13814-2-git-send-email-giometti@linux.it> <48AB55CE.30607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB55CE.30607@zytor.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 01/10] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:22:54PM -0700, H. Peter Anvin wrote:
> Rodolfo Giometti wrote:
>>  'P'	all	linux/soundcard.h
>> +'P'	00-04	linux/pps.h		LinuxPPS
>> +					<mailto:giometti@linux.it>
>
> This represents a reservation conflict even if it doesn't represent an  
> actual conflict.  If it is a reservation conflict only, please adjust  
> the range reserved for soundcards (and verify with the sound maintainers  
> that it's okay to do so); if it's an actual conflict please reassign.

I think is quicker that I reassing the codes. I'll use 'p' a0-a4 which
are free.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
