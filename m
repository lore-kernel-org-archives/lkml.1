Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZHBSqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZHBSqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZHBSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:46:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:48005 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753284AbZHBSqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:46:21 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18nQYcQC+AnvRAB8gzQajT4qHXpRSxzRfhhnPQrqG
	A/XCuWQ+4wt45H
Message-ID: <4A75DEFA.1070009@gmx.de>
Date: Sun, 02 Aug 2009 20:46:18 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/parisc fixes for 2.6.31-rc6
References: <4A75C69E.4060307@gmx.de> <20090802172137.GA28572@bombadil.infradead.org> <4A75D221.1020902@gmx.de> <20090802180636.GB28572@bombadil.infradead.org>
In-Reply-To: <20090802180636.GB28572@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2009 08:06 PM, Kyle McMartin wrote:
> On Sun, Aug 02, 2009 at 07:51:29PM +0200, Helge Deller wrote:
>> On 08/02/2009 07:21 PM, Kyle McMartin wrote:
>>> On Sun, Aug 02, 2009 at 07:02:22PM +0200, Helge Deller wrote:
>>>> Hi Linus,
>>>>
>>>> please pull the following changes for the HP parisc architecture.
>>> Uhm, I didn't authorize you to do this...
>> I'm equally authorized like you.
>>
>> MAINTAINERS file shows:
>> PARISC ARCHITECTURE
>> M:      Kyle McMartin<kyle@mcmartin.ca>
>> M:      Helge Deller<deller@gmx.de>
>
> That's not how this works.

Cool. Great argument!

>>> WTF?
>> During the development cycle of 2.6.26 up to 2.6.30, many
>> patches were not pushed upstream by someone.
>> Now I'm having a whole lot of work to push the missing patches
>> back into the stable-kernel and debian kernel series.
>> That's the reason I don't want that those patches miss 2.6.31 too...
>>
>
> Then send *me* a pull request. Don't give me a bloody end-around, it's
> simply unacceptable behaviour.

I'm missing a very important thing here:
Can you guarantee, that you will push things upstream in time?
If yes, I'm fine with sending you a push request.
If not, I don't see any other way.

Helge
