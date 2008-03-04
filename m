Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbYCDDaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbYCDDaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbYCDD3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:29:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:5731 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYCDD3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B4A7qPIR3UuL+SMJbnfBk9FhF4a0za+ukLB7Uqp9fruNRFznDbPs40wRiVuIEycbeckq5T3mbPAfDdeZUVMktr5SfjCh1F8ubO+Mkk32n1FrRYaweOFADuDrFKR34P8XCcbSje+1nA9ODmJfqKcRypQDvUgrQT0E51+kpIsxveI=
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining
	__FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
References: <1204588990.22933.28.camel@brick>
	 <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:29:54 -0800
Message-Id: <1204601394.22933.99.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 22:28 -0500, Michael Krufky wrote:
> On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > __FUNCTION__ is gcc-specific, use __func__
> >
> >  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >   162 files changed, 892 insertions(+), 892 deletions(-)
> 
> 
> If we apply this, can it be broken down into several smaller patches?
> I am in the midst of a large overhaul of the tuning subsystem, and if
> this all gets applied at once, it will wreck havoc on my pending
> changesets.
> 
> Other than that, I'm fine with this change if that's what we're doing
> across the rest of the kernel...  Would just be easier to deal with if
> it could be further broken down by subdirectory.

No worries on my part, point me at what tree you'd like it against, and
how you'd like it broken up.  Or just give me a shout when it is most
convenient to send an update.


Harvey

