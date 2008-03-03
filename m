Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYCCBCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYCCBCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYCCBB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:01:56 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50167 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751814AbYCCBB4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:01:56 -0500
To: =?utf-8?Q?Thomas_M=C3=BCller?= <thomas@mathtm.de>,
       "Eric Sandeen" <sandeen@sandeen.net>
Subject: Re: Kernel oops / XFS filesystem corruption
From: "Barry Naujok" <bnaujok@sgi.com>
Organization: SGI
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net> <47C9F5E9.70703@mathtm.de> <47CA043F.5070202@sandeen.net> <47CAF9C4.6090000@mathtm.de>
Content-Transfer-Encoding: 8bit
Date: Mon, 03 Mar 2008 12:02:43 +1100
Message-ID: <op.t7e06t193jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47CAF9C4.6090000@mathtm.de>
User-Agent: Opera Mail/9.24 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 06:02:28 +1100, Thomas Müller <thomas@mathtm.de> wrote:

> Eric Sandeen wrote:
>> oh, like a dd image?  great.
> Yup :)
>
>  > You can use xfs_metadump to make a more transportable image...
> I will, if someone needs it.
>
> As said, I have a complete file system image, so if anyone needs
> more information/data, just tell me.

I could use the metadump image for the badness in key lookups that
xfs_repair was reporting.

Thanks,
Barry.

