Return-Path: <linux-kernel-owner+w=401wt.eu-S933791AbXCFBhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791AbXCFBhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933792AbXCFBhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:37:12 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:10035 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791AbXCFBhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:37:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bm1f5owqRKmqv5HdebhGgBgIzoDeAs+bxB4qavPCa1OkaHnzHUkyYCQaFNrF1QqejV5j8Km/uQGqXNUN3dFj+oQG9u013pZ0wiXMcaIyU4gxtK9OeHJNza+M/+JIwT/4saZxuLR5tIzVQIgvMksNbB88bkn5WSIaSI8tT7kB06A=
Message-ID: <45ECC5C1.6090502@gmail.com>
Date: Tue, 06 Mar 2007 09:37:05 +0800
From: Liyu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jikos@jikos.cz>, Vincent Legoll <vincentlegoll@gmail.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Yu <raise.sail@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver
 Interface 0.5.0
References: <200703051532096508636@gmail.com>	<Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz> <d120d5000703051427r577acc82x85a70ff963b991fa@mail.gmail.com>
In-Reply-To: <d120d5000703051427r577acc82x85a70ff963b991fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> If we define HID "bus" allowing drivers to bind on VID:PID and provide
> default library module for parsing HID reports and providing access to
> HID transports (USB/BT) then writing tiny drivers adjusting just a
> part of hid_input_event and relying on default implemenattaion where
> it makes sense will become a breeze.
>
>   
Well, actually, the argument have begun since the version 0.4.0 of HID
simple
interface. I clearly know its weaknesses, and I believe Dmitry said, the
HID bus/tiny
driver way is the most ultimatest way very well.

But (You may guess I will say this word :), before the HID bus or other
better
implementation come , I hope use the extended keys of my keyboard on
Linux, and I guess other people
also think same with me, so we need something here temporarily, even it
do not merge
into upstream code tree.

And, I want to know that is somebody works on HID bus, Can I join it?

Good luck.

-Li Yu

