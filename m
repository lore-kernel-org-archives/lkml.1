Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbXBAGih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbXBAGih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXBAGih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:38:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:57888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933381AbXBAGih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:38:37 -0500
X-Authenticated: #24128601
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.20-rc7 mtrr handling
Date: Thu, 1 Feb 2007 07:38:39 +0100
User-Agent: KMail/1.9.5
References: <200701312046.02196.sebastian_ml@gmx.net> <45C18506.5090001@zytor.com>
In-Reply-To: <45C18506.5090001@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702010738.39497.sebastian_ml@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 07:13, you wrote:
> Sebastian Kemper wrote:
> > But now /proc/mtrr shows 256MB of video ram, same as lspci, whereas
> > the real amount of video ram (as properly detected by X) is only
> > 128MB.
>
> The size of the aperture doesn't have to match the actual amount of
> memory.  For many cards it doesn't.
>
> 	-hpa

Hello Peter,

sorry, I don't understand. Are you talking about the AGP Aperture size 
that I can set in my BIOS or about the actual video ram on the graphics 
card. Because that's the one that the mtrr sets to its double size.

Regards
Sebastian
