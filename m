Return-Path: <linux-kernel-owner+w=401wt.eu-S934864AbZLKHPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934864AbZLKHPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933619AbZLKHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:15:44 -0500
Received: from quoll.daa.com.au ([203.17.251.1]:54399 "EHLO quoll.daa.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbZLKHPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:15:43 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 02:15:43 EST
Message-ID: <4B21EF54.9070609@daa.com.au>
Date: Fri, 11 Dec 2009 15:05:56 +0800
From: James Andrewartha <jamesa@daa.com.au>
Organization: Data Analysis Australia
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	<20090226025043.GJ1363@mit.edu>	<20090226030735.GA16891@parisc-linux.org> <yq1myc9g9ua.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1myc9g9ua.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:
> 
> Matthew> Lowest aligned logical block address=0
> 
> Matthew> This disagrees with Martin's assertion.
> 
> The original roadmap was to transition to 4KB sectors in 2006,
> coinciding with the Vista release.
> 
> Given how long this has taken (we're now talking ~2011 for GA) it may
> very well be that the alignment knobs will be unused because everybody
> will be using Vista or 7 by then.

The plan does seem to have changed - WD's shipping 4k sector drives that are 
sane and require a drive jumper or tool for WinXP and old cloning utilities.

http://techreport.com/discussions.x/18115
http://wdc.com/en/products/advancedformat/
http://www.wdc.com/wdproducts/library/whitepapers/en/2579-771430-A00.pdf

-- 
James Andrewartha
