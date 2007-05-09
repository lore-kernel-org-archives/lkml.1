Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXEIS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXEIS13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXEIS1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:27:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbXEIS1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:27:21 -0400
Message-ID: <4642127B.9040801@zytor.com>
Date: Wed, 09 May 2007 11:27:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com> <1178669047.4747.15.camel@daplas> <20070509085434.GA13712@mailshack.com> <4641FC18.3030506@zytor.com> <20070509181838.GA17551@mailshack.com>
In-Reply-To: <20070509181838.GA17551@mailshack.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Wed, May 09, 2007 at 09:51:36AM -0700, H. Peter Anvin wrote:
>> Alexander van Heukelum wrote:
>>> Hi!
>>>
>>> I'm making coffee now. I just don't see what I missed? Maybe you were
>>> led astray by the new PARAM_VESA_PAD I added?
>>>
>> Again, I object to changing a documented interface when it's not
>> necessary to do so.  Just declare the structure packed.
> 
> That would be like this, right?
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0705.1/0383.html
> 

Absolutely.

	-hpa
