Return-Path: <linux-kernel-owner+w=401wt.eu-S1030787AbXDKECN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbXDKECN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030790AbXDKECN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:02:13 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:55674 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030787AbXDKECM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:02:12 -0400
Date: Wed, 11 Apr 2007 00:01:38 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <461BDFEA.8040602@cfl.rr.com>
To: linux-kernel@vger.kernel.org
Cc: Phillip Susi <psusi@cfl.rr.com>, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704110001.40573.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704100353.14208.gene.heskett@gmail.com> <461BDFEA.8040602@cfl.rr.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007, Phillip Susi wrote:
>Gene Heskett wrote:
>> YOU Tell the tar people, they are flabbergasted that linux is
>> apparently the only unstable OS that tar can be run on.
>
>How about cygwin/windows?  It has no concept of static device numbers.
>And what about external usb disks on any other unix os?  Surely they
>don't have static minor device numbers in the face of hot plugging?
>
>The bug is in tar and that is what needs fixed.  It should not attach
>any meaning to the device number, but rather should assume that the
>admin knows what he is doing when he said to backup a given path using a
>given incremental backup log, and that he isn't yanking tar's chain and
>pointing it to a different path between incremental backups.

I violently agree on that point, but the limited conversations I've had 
with the tar maintainer so far indicates that AFAHIC, its linux that's 
broken.  A new device number is a new disk and must be treated as such.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
QOTD:
	"I'll listen to reason when it comes out on CD."
