Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbZDKECw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbZDKECw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 00:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbZDKECn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 00:02:43 -0400
Received: from www10.cruzio.com ([63.249.93.160]:3315 "EHLO www10.cruzio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZDKECn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 00:02:43 -0400
X-Greylist: delayed 1000 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 00:02:42 EDT
Message-ID: <49E0127D.7030206@ascenium.com>
Date: Fri, 10 Apr 2009 20:46:05 -0700
From: Robert Mykland <robert@ascenium.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB auto mount - specific versus general driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Consider a USB key that auto mounts as a generic USB storage device 
using the block level driver for that.  Can I write a driver that, for 
example, is more specific to that key and gets loaded and used at auto 
mount time instead of the generic driver?  How would I go about 
identifying my driver so it superseded the generic one?

Thanks in Advance,

-- Robert.

-- 
Robert Mykland               Voice: (831) 212-0622
Founder/CTO                   Ascenium Corporation
"A new world of computing fulfilling people's lives"

