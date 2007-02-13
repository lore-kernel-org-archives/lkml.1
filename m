Return-Path: <linux-kernel-owner+w=401wt.eu-S965469AbXBMBjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbXBMBjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965470AbXBMBjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:39:03 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37087 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965469AbXBMBjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:39:01 -0500
Message-ID: <45D115C2.4010307@oracle.com>
Date: Mon, 12 Feb 2007 17:34:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Joseph Cosby <jo-cosby@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA Drive No Longer Recognized In New 2.6.20 Kernel
References: <BAY120-F18A42FB31328FBBDDFC8B183900@phx.gbl>
In-Reply-To: <BAY120-F18A42FB31328FBBDDFC8B183900@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Cosby wrote:
> Thanks.
> 
> Now having enabled the new ATA config options, the vendor-id shows up in 
> my modules pci list. But the hard drive still isn't detected by the kernel.
> 
> Is there more that needs to be enabled for this to work?

Please be more explicit about which options you enabled.
And do you still have some of CONFIG_SCSI_* enabled?  Some of those
are needed too.

so re-attach your .config file, or at least the ATA and SCSI parts of it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
