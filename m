Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755152AbYLQFGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYLQFGa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYLQFGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:06:17 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:64854 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYLQFGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:06:16 -0500
Message-ID: <494888C5.3070505@nttdata.co.jp>
Date: Wed, 17 Dec 2008 14:06:13 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.18) Gecko/20081105 Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: viro@ZenIV.linux.org.uk
CC: jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, haradats@nttdata.co.jp
Subject: Re: [PATCH] introduce new LSM hooks where vfsmount is available.
References: <49487EEF.1070207@nttdata.co.jp> <20081217044215.GV28946@ZenIV.linux.org.uk> <20081217045010.GW28946@ZenIV.linux.org.uk>
In-Reply-To: <20081217045010.GW28946@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2008 05:06:13.0721 (UTC) FILETIME=[2F0C5490:01C96005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Dec 17, 2008 at 04:42:16AM +0000, Al Viro wrote:
>> On Wed, Dec 17, 2008 at 01:24:15PM +0900, Kentaro Takeda wrote:
>>> Al, would you respond to this patch?
>>> James, Andrew and we are waiting for your Acked-by: response.
>> In queue.  FWIW, I'm about to post the current audit patchset to linux-audit,
>> push that crap to audit git and then I'm through with that turd.  And
>> _finally_ can get to VFS queue sorting.
> 
> "That crap" == audit patches for .29-rc1, that is.
I see, thank you for informing us.
We'll wait for your work.

Regards,

