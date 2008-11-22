Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYKVVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYKVVrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 16:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYKVVrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 16:47:01 -0500
Received: from lucidpixels.com ([75.144.35.66]:40030 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYKVVrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 16:47:00 -0500
Date: Sat, 22 Nov 2008 16:46:59 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Question regarding SAS controllers.
Message-ID: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do any SAS controllers exist that are not RAID?

Or to put it another way, if one wants to use SAS disks for example and 
NOT export them as JBOD or use them as RAID, is there a normal controller?

Back in the days of regular SCSI you had SCSI controllers and SCSI raid 
controllers, when searching for SAS controllers now, all that comes up is 
hundreds of SAS-Raid controllers.

Justin.

