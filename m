Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752302AbYLRHgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYLRHgX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYLRHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:36:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:55947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYLRHgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:36:12 -0500
Message-ID: <4949FD67.6040906@suse.de>
Date: Thu, 18 Dec 2008 08:36:07 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: initramfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        cjwatson@ubuntu.com, Bernhard Walle <bwalle@novell.com>
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
References: <1229540094.28858.150.camel@aglarond.local> <20081217190700.GA15377@infradead.org>
In-Reply-To: <20081217190700.GA15377@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Dec 17, 2008 at 01:54:54PM -0500, Jeremy Katz wrote:
>> As davej started talking about a few months ago at Kernel Summit and
>> LPC, there's a lot of duplication between distros on the tools used to
>> generate the initramfs as well as the contents and how the initramfs
>> works.  Ultimately, there's little reason for this not to be something
>> that is shared and worked on by everyone.  Added to this is the fact
>> that everyone's infrastructures for this have grown up over a long-ish
>> period of time without significant amounts of reworking for the way that
>> the kernel and early boot works these days.
>>
>> Therefore I've started on a new project, dracut, to try to be a new
>> initramfs tool that can be used across various distributions.  From the
>> README...
> 
> It looks like Hannes has also been working on a new, modular initramfs
> for a while:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/hare/mkinitrd.git;a=summary
> 
> I hope you guys can get together and agree on one implementation..

Thanks hch for pointing this out.

We definitely should get together to hammer our one implementation.
Having different scripts for every distributions is a PITA.

I'm not saying my implementation is the greatest on earth, so
if anyone has any better suggestions I'm all ears.

If anyone is interested I can give a short overview of it.
As per normal, proper documentation is about to be written RSN.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
