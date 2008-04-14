Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbYDNPIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbYDNPIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbYDNPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:08:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22328 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYDNPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:08:15 -0400
Message-ID: <48037315.6080305@oracle.com>
Date: Mon, 14 Apr 2008 08:07:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix typos in Documentation/filesystems/seq_file.txt
References: <28421.1208181120@vena.lwn.net>
In-Reply-To: <28421.1208181120@vena.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
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

Big Ack on that.

-- 
~Randy
