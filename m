Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYJNVC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYJNVC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYJNVCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:02:51 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36123 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYJNVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FJMTCRFz0IIn3Vyy4F1j/b5XwZCLpFORUjAra2abdlsMfD0KAM4JU0fCPyn9a9uiD9
         a8jWFjdOh1M3EufTPomQm5xKRcOYj6NQZeYoXb3BuCyblMCsQLac31EpCvPDGPefxZZc
         8bpeqighXBLC5E41lnzYfUof9ZXvAnc4KmXoM=
Subject: Re: [GIT] HID patches for 2.6.28
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <alpine.LNX.1.10.0810142205170.26779@jikos.suse.cz>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz>
	 <alpine.LFD.2.00.0810141236590.3288@nehalem.linux-foundation.org>
	 <alpine.LNX.1.10.0810142205170.26779@jikos.suse.cz>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 14:02:42 -0700
Message-Id: <1224018162.21657.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 22:12 +0200, Jiri Kosina wrote:
> On Tue, 14 Oct 2008, Linus Torvalds wrote:
> 
> > The new Kconfig options are almost uselessly described, and very 
> > annoying and this adds several new warnings of the type:
> > 	drivers/hid/hid-lg.c:342: warning: ?hid_compat_logitech? defined but not used
> > which is just unacceptable.
> 
> Hmm, this is because of Harvey Harrison's (CC added) patch that was used 
> to silence sparse warning, but it is wrong as Jiri correctly pointed out 
> on http://lkml.org/lkml/2008/9/4/495 but I somehow completely missed that 
> mail.
> 
> Will fix that up.

I thought I sent a reply agreeing with Jiri's mail shortly afterwards as
well, but I can't seem to find it...sorry for this.

Harvey

