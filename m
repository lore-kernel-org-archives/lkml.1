Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbYL2Fta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbYL2Fta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 00:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYL2FtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 00:49:22 -0500
Received: from sandeen.net ([209.173.210.139]:24348 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYL2FtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 00:49:22 -0500
Message-ID: <495864E1.9070403@sandeen.net>
Date: Sun, 28 Dec 2008 23:49:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Thomas Themel <thomas@themel.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS corruption on ARM
References: <20081228123305.GE30805@themel.com> <20081229002851.GD22525@disturbed>
In-Reply-To: <20081229002851.GD22525@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> [CC'd the xfs list.]
> 
> On Sun, Dec 28, 2008 at 01:33:05PM +0100, Thomas Themel wrote:
>> Hi,
>>
>> there was a thread[0] on this list in 2008-10 about XFS corrupting
>> rather quickly on recent ARM kernels, which seems to have petered out
>> without any apparent results. I'm still seeing the same problems with
>> 2.6.28, and I suspect that this qualifies as a kind of regression
>> (though ancient), since the devices I'm running this on (Buffalo
>> LinkStations) originally ship with a (vendor-modified) 2.6.16 kernel,
>> where XFS seems to be working.
>>
>> Is this still on anyone's radar? I'm willing to test proposed fixes and
>> supply data[1], but lack any deep knowledge of either ARM or XFS internals.
>>
>> (Please Cc: me, I'm not on the list.)

could be related to http://oss.sgi.com/bugzilla/show_bug.cgi?id=755

-Eric

>> [0] http://lkml.org/lkml/2008/10/1/382
>> [1] Though mine doesn't look any different from what was posted in [0]
>>     to the little-trained eye.

