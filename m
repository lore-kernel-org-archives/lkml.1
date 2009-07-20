Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbZGTOVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbZGTOVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZGTOVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:21:06 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:37072 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbZGTOVG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:21:06 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 10:21:05 EDT
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Date: Mon, 20 Jul 2009 16:13:22 +0200
User-Agent: KMail/1.9.9
References: <20090720040813.GC11940@kroah.com>
In-Reply-To: <20090720040813.GC11940@kroah.com>
Cc: Greg KH <gregkh@suse.de>, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907201613.22483.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. Juli 2009 schrieb Greg KH:
> I'm announcing the release of the 2.6.30.2 kernel.  All users of the
> 2.6.30 kernel series are very strongly encouraged to upgrade.
>
> I'll also be replying to this message with a copy of the patch between
> 2.6.30.1 and 2.6.30.2
>
> The updated 2.6.30.y git tree can be found at:
>        
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git and
> can be browsed at the normal kernel.org git web browser:
>        
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summa
>ry
>
> thanks,
>
> greg k-h
>

Built 2.6.30.2 but it hangs when booting immediately after the message:

Booting the kernel.

I built it with gcc version 4.3.3 on debian/sid and used exactly the 
same .config as I used with 2.6.32.1  (ok, + "DEFAULT_MMAP_MIN_ADDR 4096" 
which didn't exist before).


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196 276
Fax: +49 89 38196 150
Email: wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
