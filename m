Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbXJOAp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbXJOAp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbXJOAps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:45:48 -0400
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:34579 "HELO
	web31803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751818AbXJOApr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:45:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TfDhMQx1/tJiem5tYEria9sEmV5g/6ONA+TuSaFT5F814fyVLh0EgPIZRbe6Rf9s7IMC8FzVcvto4nAG28C8GSvoyp460532HNo+/un15SyqtaqHKomXprXeU59sAK2TDcnZBI8WQDu5LqJ2hj4am3uvgMaaje3uEZRU9rndo1o=;
X-YMail-OSG: OQPAaegVM1kSG40.H.Hk3RaughHXHjPy76_RyAiwsvgcYlpRxxdOuaUEdZI.2SVJ7ZIaPA--
Date: Sun, 14 Oct 2007 17:45:46 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: What still uses the block layer?
To: James Bottomley <James.Bottomley@SteelEye.com>,
       Matthew Wilcox <matthew@wil.cx>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
In-Reply-To: <1192400672.3351.56.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <838477.92423.qm@web31803.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Sat, 2007-10-13 at 16:05 -0600, Matthew Wilcox wrote:
> > On Thu, Oct 11, 2007 at 08:11:21PM -0500, Rob Landley wrote:
> > > My impression from asking questions on the linux-scsi mailing list is that the 
> > > scsi upper/middle/lower layers doesn't use the block layer described in 
> > > Documentation/block/*.
> > 
> > Entirely incorrect.
> 
> OK, right ... could we please get a sense of decorum back on this list.
> 
> Rob, if you didn't ask your alleged questions in such a pejorative
> manner, we'd get a lot further; and Matthew, if you didn't rise to the
> bait so spectacularly it wouldn't prolong these threads.
> 
> Really, both of you, I have better things to do with my time than
> mediate behaviours that should have been educated out of you in the
> kindergarten sand pit.

I really didn't find Rob's email "pejorative" at all.  It seems to me
he was just asking for clarification, information and trying to
understand how it all works and ties together.  His email seemed
genuine enough of a person just asking to understand how it all works.

Matthew's expletive and extremely rude response really shows
the general attitude of the linux-scsi people.

Heck, I got a similar response just a week ago here on the
list, trying to convince Garzik and his band, that storage nodes
SHOULD NOT be SAS WWN generators.  Should I have even tried?  That's
the question.

Good luck everyone,
   Luben

