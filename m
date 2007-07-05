Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXGEK30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXGEK30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 06:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbXGEK3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 06:29:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64454 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbXGEK3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 06:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BuJ7w9/RiqBVB5GbXh7Zwsl3mNXJyTx3AWUgIMGsCFewX/hPtdpBpQJ3F8LHk/JRijO/T96VuaRnsKHDWXTuZsYMYpzxVXXDYC2TL9V63ooCtbflxBurC4NMGc9dbDel4CYIl8HuKAOZZDCf2pWp/jNiv8bXeBXRb6cCqRQsPvQ=
Message-ID: <468CC7F7.90803@googlemail.com>
Date: Thu, 05 Jul 2007 12:29:11 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Paul Mackerras <paulus@samba.org>, Adrian Bunk <bunk@stusta.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: The big suspend mess
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.40890.rjw@sisk.pl> <1183497290.3388.4.camel@localhost.localdomain> <200707032332.49694.rjw@sisk.pl> <18059.5165.861038.392332@cargo.ozlabs.ibm.com> <20070704221952.GM3492@stusta.de> <20070705002747.GA2952@elf.ucw.cz> <18060.16657.2143.11489@cargo.ozlabs.ibm.com> <20070705093251.GB3228@elf.ucw.cz>
In-Reply-To: <20070705093251.GB3228@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2007-07-05 10:53:37, Paul Mackerras wrote:
>   
>> Pavel Machek writes:
>>
>>     
>>> 0. Get someone to sign up as a maintainer for suspend, so we have
>>> someone to blame for the mess? :-)
>>>       
>> I thought that was Rafael?
>>     
>
> Rafael is good job trying to fix suspend when he can, but we do not
> actually have "SUSPEND" entry in MAINTAINERS file.
> 								Pavel
>   

Huch ?;)

We do :p

...

SOFTWARE SUSPEND:
P: Pavel Machek
M: pavel@suse.cz
L: linux-pm@lists.linux-foundation.org
S: Maintained


...
