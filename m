Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0BHSBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:01:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53357 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0BHSBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:01:48 -0500
MIME-Version: 1.0
In-Reply-To: <20100125042925.GM25842@discord.disaster>
References: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
	 <20100125042925.GM25842@discord.disaster>
Date: Mon, 8 Feb 2010 13:01:46 -0500
Message-ID: <7e0fb38c1002081001y111bd0a2p40a8a896b0668d13@mail.gmail.com>
Subject: Re: linux-next: vfs/fsnotify trees build warning
From: Eric Paris <eparis@parisplace.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Eric Paris <eparis@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jan 25, 2010 at 03:04:56PM +1100, Stephen Rothwell wrote:
>> Hi Eric, Al,
>>
>> Today's linux-next build (x86_64 allmodconfig) produced these warnings:

I just switched fsnotify to use const unsigned char * so hopefully
they will shut up tomorrow....

-Eric
