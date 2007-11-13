Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXKMOS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXKMOS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXKMOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:18:48 -0500
Received: from rtr.ca ([76.10.145.34]:2280 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbXKMOSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:18:46 -0500
Message-ID: <4739B245.9040305@rtr.ca>
Date: Tue, 13 Nov 2007 09:18:45 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca>
In-Reply-To: <4739ADA2.4060604@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Andrew Morton wrote:
>> On Mon, 12 Nov 2007 22:42:32 -0800 "Natalie Protasevich" 
>> <protasnb@gmail.com> wrote:
> ..
..
>>> Suspend to RAM resume hangs on a tickless (NO_HZ) kernel
>>> http://bugzilla.kernel.org/show_bug.cgi?id=9275
>>> Kernel: 2.6.23
>>> This is HP notebook nc6320 T2400 945GM
>> No response from developers
> ..
> 
> I *still* get very slow resume-from-RAM quite often here
> (new in 2.6.22 kernel, wasn't there in early 2.6.23-rc*).
..

Typo.  That should have said:

> (new in 2.6.23 kernel, wasn't there in early 2.6.23-rc*).
