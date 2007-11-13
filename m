Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbXKMSsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbXKMSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761710AbXKMSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:47:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761699AbXKMSrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:47:55 -0500
Date: Tue, 13 Nov 2007 10:47:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Martin Bligh" <mbligh@google.com>
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Natalie Protasevich" <protasnb@gmail.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113104714.bf008041.akpm@linux-foundation.org>
In-Reply-To: <33307c790711130946j3ae10dcx9d776bc9671710f7@mail.gmail.com>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	<20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<1194968001.3416.12.camel@localhost.localdomain>
	<33307c790711130946j3ae10dcx9d776bc9671710f7@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 09:46:08 -0800 "Martin Bligh" <mbligh@google.com> wrote:

> > > > http://bugzilla.kernel.org/show_bug.cgi?id=9267
> > > > Kernel: 2.6.23.1
> > >
> > > No response from developers
> >
> > Urm, well, if no-one ever tells the SCSI list it's unrealistic to expect
> > anyone to be working on it.  As far as I can tell, email was sent to
> > Andrew Vasquez only on 31 October. However, the fault looks to be
> > generic, so he probably just dropped it.

I looked at that one and decided not to forward it to anyone because it was
already sent to Andrew.  Oh well, sorry.

> This is a technical issue with vger.kernel.org mailing lists that I've tried
> addressing before - maybe davem can help fix it?
> 
> What I've tried doing is bouncing relevant postings from my procmail
> filters to the list, but it seems to drop bounces (probably as spam).
> Is there any way around this? (like can I get an exception to be allowed
> to bounce stuff or mark it with some magic X-secret-knock: header?)

Please let me know asap if/when this starts working so I don't start
forwarding duplicates everywhere.

