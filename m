Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbXHWME6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbXHWME6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbXHWMEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:04:51 -0400
Received: from gw.unix-scripts.info ([62.212.121.204]:59890 "EHLO
	gw.unix-scripts.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbXHWMEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:04:50 -0400
Message-ID: <46CD77DC.40807@unix-scripts.info>
Date: Thu, 23 Aug 2007 14:04:44 +0200
From: Laurent CARON <lcaron@unix-scripts.info>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Server crashes unexpectedly
References: <46CD6C40.7070403@unix-scripts.info> <20070823114908.GD31846@slug>
In-Reply-To: <20070823114908.GD31846@slug>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> On Thu, Aug 23, 2007 at 01:15:12PM +0200, Laurent CARON wrote:
>> Hi,
>>
>> One of my server crashes randomly.
>>
>> I suspect a filesystem corruption.
> What makes you think so?  I'd check the memory with memtest.


I suspect the filesystem, because it happened to me on 2 other servers
in the past.

A reiserfs3 corruption occured, making the server crash with the same
kind of symptoms but that's only a guess).

Checking with memtest asap.

Thanks

Laurent
