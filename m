Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZLCRbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZLCRbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZLCRbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:31:08 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:37928 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZLCRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xjSjWIb6yzvM6yfxxl62NvlrxI1fhuLAmY/38lugWzXfPwh6clBofSxKMHJdmdQWC2
         +8k8V5bIHY2o9mJsbPXb5LY726ujnYNYVQ/MbtURgZJn61eYpi997XrYK22wOuoxZQmM
         AaxNsUwujNjb9fEw3VoEg+SeQvvuCCjnzsAEQ=
Date: Thu, 3 Dec 2009 09:31:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ferenc Wagner <wferi@niif.hu>, Jarod Wilson <jarod@wilsonet.com>,
       Jarod Wilson <jarod@redhat.com>, Jon Smirl <jonsmirl@gmail.com>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
       j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091203173105.GA776@core.coreip.homeip.net>
References: <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com> <4B16BE6A.7000601@redhat.com> <20091202195634.GB22689@core.coreip.homeip.net> <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com> <20091202201404.GD22689@core.coreip.homeip.net> <4B16CCD7.20601@redhat.com> <20091202205323.GF22689@core.coreip.homeip.net> <4B16D87F.7080701@redhat.com> <87tyw8ujsr.fsf@tac.ki.iif.hu> <4B17E874.5020003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B17E874.5020003@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 02:33:56PM -0200, Mauro Carvalho Chehab wrote:
> Ferenc Wagner wrote:
> > Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> We should not forget that simple IR's don't have any key to select the address,
> so the produced codes there will never have KEY_TV/KEY_DVD, etc.

Wait, wait, KEY_TV, KEY_DVD, KEY_TAPE - they should be used to select
media inputs in a device/application. My receiver accepts codees like
that.

-- 
Dmitry
