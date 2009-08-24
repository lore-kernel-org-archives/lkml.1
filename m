Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZHXQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZHXQK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZHXQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:10:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZHXQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:10:22 -0400
Message-ID: <4A92BB3B.6070305@zytor.com>
Date: Mon, 24 Aug 2009 09:09:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix build with older binutils and		 consolidate
  linker script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com> <4A8F0228.80805@zytor.com> <4A92557002000078000113DD@vpn.id2.novell.com> <4A923D98.4090501@zytor.com> <4A925B930200007800011409@vpn.id2.novell.com>
In-Reply-To: <4A925B930200007800011409@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 12:21 AM, Jan Beulich wrote:
> In any case, it would seem that this would be an independent patch on top
> of mine...

Agreed.  I'll look at it later.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

