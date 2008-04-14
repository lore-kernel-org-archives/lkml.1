Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbYDNO0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbYDNO0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbYDNOV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761707AbYDNOV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lmZtBQcQyFpqPWA7y/8WicmTgN3lELv47O5ysLEKPXaiUFambjSiY5W6la6gwRvRg8gltwoYs+Y2GuaifB2PSF0fchUaPHJK/5VnMp18FyzT9CrukMlbyNN6VWpFL95/KU3bwKPjVjZ2XWl517ukVcQ9FsSE6438WDHoESxDorA=
Message-ID: <4803687A.2060404@gmail.com>
Date: Mon, 14 Apr 2008 18:21:46 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Al Viro <viro@ZenIV.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
References: <28421.1208181120@vena.lwn.net>
In-Reply-To: <28421.1208181120@vena.lwn.net>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet пишет:
> Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
>> Offhand, it seems that the double spacing convention is being currently used
>> in a more or less consistent manner throughout Linux docs. It also seems to
>> me that this can be made a requirement and documented somewhere.
> 
> Double spacing is my preference, and I appreciate your sending a new
> patch which doesn't take that out.
> 
> But *please* let's not try to make "requirements" along those lines.  If
> somebody's going to go to the trouble to write some documentation, I
> don't think we really want people bouncing it back to them with 100
> "single space after period" errors from checkpatch.pl...
> 

OK, clear enough. Thanks.

Dmitri

> Thanks,
> 
> jon
> 

