Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYCCBD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYCCBD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYCCBDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:03:52 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35109 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbYCCBDv (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:03:51 -0500
Message-ID: <47CB4E20.5070808@sgi.com>
Date: Mon, 03 Mar 2008 12:02:24 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
Organization: SGI Engineering
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel oops / XFS filesystem corruption
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net> <47C9F5E9.70703@mathtm.de> <47CA043F.5070202@sandeen.net>
In-Reply-To: <47CA043F.5070202@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric Sandeen wrote:
> Thomas Müller wrote:
>> Eric Sandeen wrote:
>>> Did you also happen to save the xfs_repair output?
>> No, but I made a complete copy of the file system before
>> repairing it, so I can easily recreate it... :)
> 
> oh, like a dd image?  great.  You can use xfs_metadump to make a more
> transportable image... xfs folks might even be able to use that to
> recreate the oops.

YES PLEASE. See the xfs_metadump man page for instructions. It will
obfuscate filenames by default (but please only do so if you need to).

Please make it available for Barry, thanks.

Cheers
-- Mark
