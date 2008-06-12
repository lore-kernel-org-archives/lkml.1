Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbYFLIfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbYFLIfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYFLIfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:35:12 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:1130 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYFLIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:35:10 -0400
Message-ID: <4850DFB4.5020205@wpkg.org>
Date: Thu, 12 Jun 2008 10:35:00 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: shawnxjin@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Force a usb drive to be /dev/sda?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it possible to force a usb drive to be /dev/sda? I put an entire
> linux system to a usb drive and want it boot a system with variable
> sata disks. However the usb drive is always scanned as a last scsi
> drive.

Is there a reason why you can't use filesystem labels or UUIDs?


-- 
Tomasz Chmielewski
http://wpkg.org

