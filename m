Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbYEJSmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbYEJSmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 14:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYEJSmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 14:42:40 -0400
Received: from elrond2.infotech.no ([82.134.31.41]:33573 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbYEJSmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 14:42:39 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 May 2008 14:42:39 EDT
Message-ID: <4825EAA0.5030305@torque.net>
Date: Sat, 10 May 2008 14:34:08 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: Re: lsscsi is broken
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
In-Reply-To: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which version of lsscsi?
[For example what is the output of 'lsscsi --version'.]

If it is not version 0.20 beta could you try it.
See: http://sg.torque.net/scsi/lsscsi.html


Doug Gilbert


Yinghai Lu wrote:
> LBSuse:~ # lsscsi
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: left parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> sdev_scandir_sort: right parse failed
> [target0:0:0]type?   vendor?  model?           rev?  -
> [target1:0:0]type?   vendor?  model?           rev?  -
> [target2:0:0]type?   vendor?  model?           rev?  -
> [target3:0:0]type?   vendor?  model?           rev?  -
> [target6:0:0]type?   vendor?  model?           rev?  -
> [target7:0:0]type?   vendor?  model?           rev?  -
> [target8:0:0]type?   vendor?  model?           rev?  -
> [target9:0:0]type?   vendor?  model?           rev?  -
> [target12:0:0]type?   vendor?  model?           rev?  -
> [0:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [1:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [2:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [3:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [6:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [7:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [8:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [9:0:0:0]    disk    ATA      FUJITSU MHY2200B 0086  -
> [12:0:0:0]   cd/dvd  TSSTcorp CD/DVDW TS-T632A SR03  -
> 
> 
> Linux LBSuse 2.6.26-rc1-sched-devel.git-x86-latest.git-00589-g5bb43f9-dirty
> #372 SMP Thu May 8 18:54:33 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



