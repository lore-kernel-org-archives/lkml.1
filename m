Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYCBBfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYCBBfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 20:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYCBBe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 20:34:57 -0500
Received: from sandeen.net ([209.173.210.139]:17181 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYCBBe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 20:34:56 -0500
Message-ID: <47CA043F.5070202@sandeen.net>
Date: Sat, 01 Mar 2008 19:34:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>
CC: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: Kernel oops / XFS filesystem corruption
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net> <47C9F5E9.70703@mathtm.de>
In-Reply-To: <47C9F5E9.70703@mathtm.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Müller wrote:
> Eric Sandeen wrote:
>> Did you also happen to save the xfs_repair output?
> No, but I made a complete copy of the file system before
> repairing it, so I can easily recreate it... :)

oh, like a dd image?  great.  You can use xfs_metadump to make a more
transportable image... xfs folks might even be able to use that to
recreate the oops.

-Eric
