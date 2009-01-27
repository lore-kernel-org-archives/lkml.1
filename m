Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZA0Ai3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZA0Ai3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZA0AiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:38:16 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:53796 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZA0AiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:38:15 -0500
Message-ID: <497E576C.7050605@oracle.com>
Date: Mon, 26 Jan 2009 16:38:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nicklas Widlund Bjurman <lordmetroid@gmail.com>
CC: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: SYS_rename for FAT32
References: <36d886900901261633r3b3018b4led0bd980816f4d88@mail.gmail.com>
In-Reply-To: <36d886900901261633r3b3018b4led0bd980816f4d88@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.497E576F.012E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicklas Widlund Bjurman wrote:
> Hi, I'm a new Linux kernel developer.
> 
> I filed a bug two weeks ago( https://bugs.launchpad.net/bugs/315782 )
> and now after some further research to determine the bug's location, I
> am now determined to patch it.
> 
> I searched http://lxr.linux.no/linux+v2.6.28.2/+search after
> SYS_rename to see what the process is for renaming a file however I
> can't find anything. Could anyone knowledgeable of the kernel point me
> to where I should start digging?

Hi,
I suggest that you cc: the FAT fs maintainer.  (done)

-- 
~Randy
