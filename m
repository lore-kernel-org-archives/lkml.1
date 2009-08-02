Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZHBRve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZHBRve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZHBRvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:51:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:45480 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753213AbZHBRvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:51:33 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX184gpVgUys4bvxPaaCM5RUZ8IG/8bp9sk0l4Z4Ug6
	pS5vYrAJU6C5cs
Message-ID: <4A75D221.1020902@gmx.de>
Date: Sun, 02 Aug 2009 19:51:29 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/parisc fixes for 2.6.31-rc6
References: <4A75C69E.4060307@gmx.de> <20090802172137.GA28572@bombadil.infradead.org>
In-Reply-To: <20090802172137.GA28572@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2009 07:21 PM, Kyle McMartin wrote:
> On Sun, Aug 02, 2009 at 07:02:22PM +0200, Helge Deller wrote:
>> Hi Linus,
>>
>> please pull the following changes for the HP parisc architecture.
>
> Uhm, I didn't authorize you to do this...

I'm equally authorized like you.

MAINTAINERS file shows:
PARISC ARCHITECTURE
M:      Kyle McMartin <kyle@mcmartin.ca>
M:      Helge Deller <deller@gmx.de>

>WTF?

During the development cycle of 2.6.26 up to 2.6.30, many
patches were not pushed upstream by someone.
Now I'm having a whole lot of work to push the missing patches
back into the stable-kernel and debian kernel series.
That's the reason I don't want that those patches miss 2.6.31 too...

Helge
