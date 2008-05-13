Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYEMBbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYEMBbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbYEMBbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:31:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36941 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbYEMBbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:31:08 -0400
Message-ID: <4828EF2A.1090302@oracle.com>
Date: Mon, 12 May 2008 18:30:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 12
References: <20080512150418.603e29cf.sfr@canb.auug.org.au>	<20080512082205.8678bbaf.randy.dunlap@oracle.com> <20080513103055.d133f60a.sfr@canb.auug.org.au>
In-Reply-To: <20080513103055.d133f60a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Randy,
> 
> On Mon, 12 May 2008 08:22:05 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Mon, 12 May 2008 15:04:18 +1000 Stephen Rothwell wrote:
>>
>>> News:  I am now providing patches relative to the latest tag in Linus'
>>> tree.  I propose to stop providing complete tar balls as they are so
>>> large and people will have recent versions of Linus's tree anyway (I
>>> assume).  The patches will be named "patch-<upstream tag>-<next tag>".
>> Oh well.  For the record, I don't mind using patches instead of
>> complete tarballs, but I would prefer that the patches be relative
>> to something like a daily -git snapshot so that using git is not
>> required at all.
> 
> They will be relative to a tag that Linus adds to his tree and those
> tagged trees are always available as tar balls.  i.e. yesterdays patches
> were relative to 2.6.26-rc1, today's (and until rc3 comes out) will be
> relative to 2.6.26-rc2. Or I could do them against the daily -git
> snapshots (or both).  Either way it would cut down on the amount of stuff
> I am distributing. Currently there is already about 6G of linux-next
> tarballs.

That sounds fine.  Relative to -rc's is good IMO (and for my scripts).

> I certainly don't want to make it harder for those who are doing such
> good job of testing. Does that make it clearer?

Yes.  Thanks.

-- 
~Randy
