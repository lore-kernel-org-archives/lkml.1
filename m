Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZEIBUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZEIBUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZEIBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:20:37 -0400
Received: from www10.cruzio.com ([63.249.93.160]:4624 "EHLO www10.cruzio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZEIBUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:20:37 -0400
Message-ID: <4A04CB41.3040008@ascenium.com>
Date: Fri, 08 May 2009 17:16:01 -0700
From: Robert Mykland <robert@ascenium.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Vendor info from device name
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I am inside a file system driver, a modified version of vfat to be 
exact, trying to get vendor info that uniquely identifies a USB storage 
device that's associated.  I have the device name coming into 
vfat_get_sb().  I looked down through the associated structures I get 
here but nothing obvious pops out.  What's the best way to get down to 
the vendor/unique device info from here?  Thanks in advance for your 
help and apologies in advance if this is a dumb question.

Regards,

-- Robert.

-- 
Robert Mykland               Voice: (831) 212-0622
Founder/CTO                   Ascenium Corporation
"A new world of computing fulfilling people's lives"

