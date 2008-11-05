Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYKEUPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYKEUPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYKEUPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:15:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:28879 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYKEUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BB9xz6OSNfyuhGfiZX7pUQqgZvzykRpa53Jwp72ddPT0E9UFjfkSkxdXvFSktQuvsG
         0whh86QxNL0okqV+mppUcRxO3GYR3syIihBAIPcvFs06ecNg5tbjPGajFa7llkFThfT9
         bzahLN1KSHs0kZ/ZcY5fB8frJPE6viDWAXCHw=
Message-ID: <3aaafc130811051215v6a66e9f6n125ffd3727c5a6ed@mail.gmail.com>
Date: Wed, 5 Nov 2008 15:15:05 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC PATCH V4 0/6] In-kernel IR remote control support
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9e4733910811051207w4e57086eq3c02f96c9530add6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105194640.19407.19682.stgit@localhost>
	 <3aaafc130811051159y1e2fb70fg6b1b915a07daf58e@mail.gmail.com>
	 <9e4733910811051207w4e57086eq3c02f96c9530add6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 3:07 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Wed, Nov 5, 2008 at 2:59 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
>> On Wed, Nov 5, 2008 at 2:47 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
>>> New release of in-kernel IR support implementing evdev support. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices. Still looking for help with this project.
>>
>> (Forgive me if this has already been asked or dealt with)
>>
>> Have you contacted the LIRC developers? Is there any overlap between
>> your projects?
>
> The LIRC people know about this. Pieces of the code are coming from
> the LIRC source base and being reworked for kernel inclusion.

Great, it's nice to see there's cooperation.

>
> LIRC needs a daemon to run and apps have to be modified to use it.
> This code runs all in-kernel and looks like keyboard input to apps.
>
> LIRC developers and anyone else and encouraged to help with this code.

What's involved in converting an LIRC driver into something usable
with your framework?

>
> --
> Jon Smirl
> jonsmirl@gmail.com
>
