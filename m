Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbYCWMYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbYCWMYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759176AbYCWMY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:24:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:34190 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbYCWMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gu/s3STwcXEfyJq/1J3eMNOZMrpaXAzS2P7jyA/IKt3lYMZOB60MVOEYx6us6N02yoAopm5jo0fnKBdZ181ipW25ynz92JvRGGbKBvI6qkSRAwkt7cCjp95xiNRn1niv+E9WMOfccGMX765sHVZwOgcbi7HTdfE6LrNnl+KR75c=
Message-ID: <47E64BF7.4070808@gmail.com>
Date: Sun, 23 Mar 2008 13:24:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: viro@ZenIV.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
References: <20080323085210.GE10722@ZenIV.linux.org.uk>	<20080323.032013.79276201.davem@davemloft.net>	<47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net>
In-Reply-To: <20080323.051929.267232495.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2008 01:19 PM, David Miller wrote:
> There are mountains of more useful stuff to be working on (much of it
> automated, but unlike checkpatch work doesn't result in crap) rather
> than 148 patches of checkpatch vomit.
> 
> Fixing sparse warnings properly fixes real issues, whereas fixing
> checkpatch stuff creates garbage 9 times out of 10.

Yes, I agree with you in this.

What I don't agree with is that it's useless. It may help track down some issues 
in yet prepared patch (it's checkpatch, not checkcode and it should be used in 
that manner).
