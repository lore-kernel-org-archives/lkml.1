Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbYCWMGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbYCWMGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbYCWMGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:06:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:1202 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbYCWMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ohsmTFrJloLdeyHTyPnqTxLiqV5VO9nEQcqFlizQZCTBKzrpUp2xb8RwS+esufGAkhRIvWdi5noVoQhtfADxQh8nAhu84qhwUyc+3o0mH4dVWsRoeJsi7mfPeszkPdwT705lY3q+1cskbkKkAAnurbbF9cK/EVzOVx5cEzvIV+U=
Message-ID: <47E647AC.1060906@gmail.com>
Date: Sun, 23 Mar 2008 13:06:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: viro@ZenIV.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
References: <1206259443-13210-1-git-send-email-joe@perches.com>	<1206259443-13210-110-git-send-email-joe@perches.com>	<20080323085210.GE10722@ZenIV.linux.org.uk> <20080323.032013.79276201.davem@davemloft.net>
In-Reply-To: <20080323.032013.79276201.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2008 11:20 AM, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sun, 23 Mar 2008 08:52:10 +0000
> 
>> On Sun, Mar 23, 2008 at 01:03:24AM -0700, Joe Perches wrote:
>>> Signed-off-by: Joe Perches <joe@perches.com>
>> An obvious corollary to this highly inspired series of patches:
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> I totally agree, checkpatch is just shit.

I disagree. It's just misuse in this case (like using Lindent on whole tree).
