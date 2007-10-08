Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXJHCsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXJHCsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 22:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXJHCsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 22:48:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38221 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbXJHCsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 22:48:31 -0400
X-Sasl-enc: 4/CFOtLxEje6T6P1X907ntTXw74G1WQQGpR4ZxjmbNLt 1191811709
Message-ID: <47099A73.4020703@fastmail.co.uk>
Date: Mon, 08 Oct 2007 10:48:19 +0800
From: Max Waterman <davidmaxwaterman+kernel@fastmail.co.uk>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Barry Naujok <bnaujok@sgi.com>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <47098DD4.4090207@fastmail.co.uk> <op.tzuxcgsi3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tzuxcgsi3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Barry Naujok wrote:
> Yes, the latest xfs_repair doesn't create a lost+found unless it
> needs to, and if it does so, it will list the inodes moved there.
>
> So, in your case, nothing went to lost+found.
>
> Regards,
> Barry.
Great. Thanks a lot for your help :)

Max.

PS. I'm still missing working at SGI :|
