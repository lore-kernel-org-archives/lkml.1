Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZBOMQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZBOMQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZBOMQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:16:50 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47578 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbZBOMQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:16:49 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
Date: Sun, 15 Feb 2009 13:17:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       John Stoffel <john@stoffel.org>, Len Brown <lenb@kernel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902140917.38313.philippe.grenard@laposte.net> <3f9a31f40902140124j4bb07aeej8af3dff89e347318@mail.gmail.com>
In-Reply-To: <3f9a31f40902140124j4bb07aeej8af3dff89e347318@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151317.11690.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009 10:24:51 Jaswinder Singh Rajput wrote:
> On Sat, Feb 14, 2009 at 1:47 PM, Philippe Grenard
>
> <philippe.grenard@laposte.net> wrote:
> > On Friday 13 February 2009 21:48:30 John Stoffel wrote:
> >> Here's your problem most probably.  The nVidia graphics module.
> >> Remove that and re-try your system.  Basically, we can't help you when
> >> you use a vendor's binary module.
> >>
> >> John
> >
> > Well, it does not change anything to my problem...
> > Moreover, I don't understand why this would work with 2.6.27.10 but not
> > with 2.6.29-rc4 ....
>
> May be nvidia graphics module was written based on some kernel which
> is more closer to 2.6.27.10 as compare to 2.6.29-rc4.
>
> Another thing which John is pointing configure your bios to use
> standard inbuild garphics card OR remove nvidia module and check
> whether it solves your problem or not.
>
> --
> JSR
As I said just before, I tried it but it does not change my problem : the 
system still stalls randomly, sometimes during boot, sometimes after...

Thanks for your help,

Philippe
