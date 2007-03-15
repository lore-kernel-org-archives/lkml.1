Return-Path: <linux-kernel-owner+w=401wt.eu-S965412AbXCOMUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412AbXCOMUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965490AbXCOMUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:20:11 -0400
Received: from mx-sanjose.Cadence.COM ([158.140.2.60]:53720 "EHLO
	mx-sanjose.cadence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412AbXCOMUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:20:09 -0400
X-Greylist: delayed 3542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 08:20:09 EDT
Message-ID: <45F92C1E.2040604@cadence.com>
Date: Thu, 15 Mar 2007 16:51:02 +0530
From: Sai Bhushan <sbhushan@cadence.com>
Reply-To: sbhushan@cadence.com
Organization: Cadence Design Systems India Pvt. Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624 Netscape/7.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Files not visible across NFS
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2007 11:21:02.0305 (UTC) FILETIME=[03ACAD10:01C766F4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am facing a problem where-in some files are not visible across NFS and 
hence, not able to read those files. However, after sometime, the files 
become visible and the data is accessible. I have tried to do an 'ls -l' 
operation on the directory and repeat it till the directory gets mounted 
and visible. This works in some cases but sometimes fails as well.

Is there any reliable way of ensuring that the directory gets mounted 
and all files in it are visible before accessing the data ??

Any help/pointers in this regard would be really great.

-Thanks & Regards
Sai

