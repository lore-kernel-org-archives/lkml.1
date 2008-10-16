Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYJPOad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYJPOad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYJPOaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:30:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36938 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYJPOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:30:25 -0400
Message-ID: <48F74FCC.6080002@oracle.com>
Date: Thu, 16 Oct 2008 07:29:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: MAINTAINERS: add F: and acronyms
References: <200810130059.m9D0xLgN029583@hera.kernel.org> <Pine.LNX.4.30.0810122111080.14681-100000@perches.com> <20081016103332.GA1563@ucw.cz>
In-Reply-To: <20081016103332.GA1563@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2008-10-12 21:17:31, Joe Perches wrote:
>>>     MAINTAINERS: add F: and acronyms
>>>     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Does this mean that file patterns will now be accepted into
>> MAINTAINERS?  If so, I have a rather long list of patches.

I was just documenting what was already in the file.

> Pretty please... today I was searching for hwmon maintainer and guess
> what, it is listed as 'hardware monitoring' and orphaned.

I'm not a big fan of the file patterns, but we can certainly
add HWMON or hwmon to the file IMO.

>> What about scripts using those patterns?

-- 
~Randy
