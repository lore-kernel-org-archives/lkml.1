Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbZIDQi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbZIDQi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZIDQi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:38:29 -0400
Received: from mx0.towertech.it ([213.215.222.73]:34935 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932182AbZIDQi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:38:28 -0400
Date: Fri, 4 Sep 2009 18:38:28 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: Add boot_timesource sysfs
 attribute
Message-ID: <20090904183828.4376236e@i1501.lan.towertech.it>
In-Reply-To: <20090904163029.GA25239@srcf.ucam.org>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
	<1252081568-6000-2-git-send-email-mjg@redhat.com>
	<20090904182528.591dbd29@i1501.lan.towertech.it>
	<20090904163029.GA25239@srcf.ucam.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 17:30:29 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> We'd prefer to avoid always doing --hctosys because it's a 
> noticable performance hit on boot if the work's already been done by the 
> kernel.

 it shouldn't. maybe your hwclock is waiting for the tick
 or something similar. I'd check it.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

