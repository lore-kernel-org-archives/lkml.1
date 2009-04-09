Return-Path: <linux-kernel-owner+w=401wt.eu-S1764354AbZDIKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764354AbZDIKJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932769AbZDIKJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:09:06 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:59413 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765953AbZDIKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:09:03 -0400
Message-ID: <49DDC93B.8020106@in.ibm.com>
Date: Thu, 09 Apr 2009 15:38:59 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Next April 9 : x86 allmodconfig media/video/cx88 build break
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
In-Reply-To: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's Next tree allmodconfig build on x86 failed with

ERROR: __divdi3 [drivers/media/video/cx88/cx88xx.ko] undefined!

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

