Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0BNTB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:01:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49420 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab0BNTB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:01:26 -0500
Message-ID: <4B78482F.2070809@kernel.org>
Date: Sun, 14 Feb 2010 10:59:59 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jean Delvare <khali@linux-fr.org>, Willy Tarreau <w@1wt.eu>,
       mirrors@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <20100214170724.GE1578@ucw.cz>
In-Reply-To: <20100214170724.GE1578@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 09:07 AM, Pavel Machek wrote:
> Hi!
> 
>> As a matter of fact, I am advocating the use of xz while I don't have
>> it installed on most of my machines. I really don't see this as a
>> blocker.
> 
> Eh?
> 
> Making many people around the world install uncommon tool is not
> something that should be done lightly.
> 

Indeed.

Let me make this straight before we waste more breath on this: we're not
going to go to xz only at this time.  Heck, we were getting pushback on
the idea of going to bz2 only *ten years* after it was deployed.

	-hpa
