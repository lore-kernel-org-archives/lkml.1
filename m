Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYGHFOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYGHFOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbYGHFOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:14:22 -0400
Received: from mail.lang.hm ([64.81.33.126]:51143 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYGHFOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:14:22 -0400
Date: Mon, 7 Jul 2008 22:15:21 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: "Altobelli, David" <david.altobelli@hp.com>, Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
In-Reply-To: <20080707214905.157be089@infradead.org>
Message-ID: <alpine.DEB.1.10.0807072212450.12950@asgard.lang.hm>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
 <alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm> <20080707214905.157be089@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Arjan van de Ven wrote:

> On Mon, 7 Jul 2008 21:41:41 -0700 (PDT)
> david@lang.hm wrote:
>> umm, by merging the code a you reveal a lot of what they are
>> attempting to keep secret. what's to stop someone from reading the
>> code and writing the documentation?
>>
>> that really should be someone at HP if you don't want to publish the
>> exising documentation (since you are submitting the code)
>>
>
> Hi,
>
> I think you're being quite unreasonable here.
> In Linux we accept well written drivers even if there is no hardware
> docs. Sure we prefer them to be available, but is has never been a
> requirement, nor should it. I know that some other open source OSes do
> demand this, but Linux is not one of them. We explicitly accept drivers
> written with NDA docs, or drivers written by vendors.
> It's the code that talks.
> (and well written code is often worth more than the shoddy docs that we
> sometimes get)

sorry, I did not mean to imply that they code cannot be accepted, just to 
point out that the 'secrets' that they are trying to protect are revealed 
by the code anyway, and that someone will eventually need to do the work 
to reverse-engineer some portion of the documentations, and that it's 
best if it could come from the folks submitting it when they have the 
origional documentation.

a driver with no docs is better then a closed source driver, but is not 
nearly as good as a driver with docs.

David Lang
