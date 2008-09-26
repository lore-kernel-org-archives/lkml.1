Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYIZVA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYIZVA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYIZVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:00:20 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42051 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYIZVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cG8czulb4s3VfH9KluEOx1qZkqTLq9xDHfF1IrjqncTX7MLS7lpgMglK8UjjPHRaDu
         6k7fUmUWlR16vUps4bcscmQyDhTfBdOBUtZu1dRXQv+jZQdXhPFnViGQHZJo1m/PTQyW
         SPilypS1+VulnINRrlH567Mh9qHGf9lArhptU=
Message-ID: <c384c5ea0809261400u43a3ee57y62083d20867f1cc6@mail.gmail.com>
Date: Fri, 26 Sep 2008 23:00:17 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Parag Warudkar" <parag.lkml@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <20080926201917.GA2591@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080925020608.GA13869@suse.de> <20080925042108.GA3931@suse.de>
	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
	 <20080925205328.GB11225@suse.de>
	 <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
	 <20080925220454.GA12116@suse.de>
	 <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com>
	 <48DD2BA3.7050808@s5r6.in-berlin.de>
	 <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
	 <20080926201917.GA2591@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 26, 2008 at 10:19 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Sep 26, 2008 at 04:11:49PM -0400, Parag Warudkar wrote:
>> On Fri, Sep 26, 2008 at 2:36 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>
> If you really don't like it, just never enable any of these modules,
> you'll never be bothered by it.
>
I would like new drivers for new devices to live into the wild.

Seriously, I think it's a good think to have new drivers lift along
with the kernel source distribution to get *much* wider attention,
testing, hacking and feedback.

I propose GREG_GOES_WILD and I will happily commit my
driver-in-progress to the kernel staging areas instead of to some
two-people-know-about-it-location.

Thanks for the effort, Greg,

Regards,
-- 
Leon
