Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXDDSCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXDDSCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXDDSCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:02:55 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47569 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXDDSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:02:53 -0400
Message-ID: <4613E7FB.20601@gmail.com>
Date: Wed, 04 Apr 2007 20:01:31 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet> <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com> <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <s5hps6kxefx.wl%tiwai@suse.de> <20070404174839.GQ27660@stusta.de>
In-Reply-To: <20070404174839.GQ27660@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2007 07:48 PM, Adrian Bunk wrote:

> On Wed, Apr 04, 2007 at 07:00:18PM +0200, Takashi Iwai wrote:

>> But in general, it would be nice to have an easy way to find a
>> maintainer (not author) from a module binary, and I agree
>> MODULE_MAINTAINER can work well for such a purpose.  It's no mandatory
>> field, but could be some help.
> 
> Yes, it would be nice.
> 
> But would this information always be kept up-to-date for the whole tree?
> I don't see this happen.

I believe it would largely stay up to date yes. The tag wouldn't be 
mandatory and adding oneself as a MODULE_MAINTAINER would specifically 
be saying "yes, I want to look after this thing". If someone then no 
longer wants to, getting rid of the tag is a matter of deleting one 
line. I wouldn't be worse than MAINTAINERS, and being inline, I expect 
it to be better...

Rene.
