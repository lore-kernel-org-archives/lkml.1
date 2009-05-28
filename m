Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbZE1StR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbZE1StR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZE1StK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:49:10 -0400
Received: from main.gmane.org ([80.91.229.2]:46492 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758310AbZE1StJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:49:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: regression i915 / video driver
Date: Thu, 28 May 2009 20:48:44 +0200
Message-ID: <20090528204844.58bf12d6@schatten>
References: <609771.46526.qm@web112217.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: intel-gfx@lists.freedesktop.org
X-Gmane-NNTP-Posting-Host: f053210127.adsl.alicedsl.de
In-Reply-To: <609771.46526.qm@web112217.mail.gq1.yahoo.com>
X-Newsreader: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 09:44:23 -0700 (PDT)
We La <w.landgraf@yahoo.com> wrote:

> 
> I inform that the problem with the i915 driver isnt yet resolved !!
> 
> On the last kernel git's, at least on my ms wind 100 laptop, the
> video driver don't load correctly, and correspondingly the i915
> driver don't load at all, as explained before.   With exactly the
> same system but booting with 2.6.29.4 (and all previous 2.6.29.X) the
> problem dont exist and everything works correctly.
> 
> Werner LAndgraf
> 
> SYS
> 
Hi!

Do you have filled a bugzilla entry or have send previously messages to
this list?

It would be nice to include references to both such actions if they
took place. As there are quite a number of messages coming through this
list, it is likely, that your messages didn't get noticed before. 

[i searched through lkml for your mailadress and found some messages,
which took me some time, but consider it a favour]:
 http://lkml.org/lkml/2009/5/1/215
 http://lkml.org/lkml/2009/4/30/731


Please file a bug at http://bugzilla.kernel.org/ and classify it as
a regression from 2.6.29. Also put all information available to you
about this bug in there. 
This makes it easy to reference it. 

The second step would be to assume that nobody noticed your messages
before and thus include all relevant information in each message,
making it easy for somebody reading it to understand what it is about.
(if you just have to quote a bugzilla bug number, of course, that's
easy)

The third step would probably be, to find someone to talk to. An email
about i915 is likely to get more attention on
intel-gfx@lists.freedesktop.org 

And it would be kind of you to read
http://www.kernel.org/pub/linux/docs/lkml/ . (spcifically the
mailinglist 'rules'... )

out of respect to others, so that they (I?) don't have to do
unnecessary work. 

Especially:
1. If you are replying to a specific mail, plz include the relevant part
of it you are replying to and 
2. use your mail-clients reply-to-all button, so that the mail get's
linked to the mail you are replying to. 

Sincerely,
Florian



