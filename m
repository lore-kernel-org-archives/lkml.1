Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbZLQUa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbZLQUa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZLQUax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:30:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:1478 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbZLQUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Do5xiydlmQjVj+VY1WqKDljxvg8avkzF6ON/QhHqDkDr/yB5uLmEmUlGs7Ib1Tx8+d
         KALqpBtprxVybkwypUcXNrromWjRAGfJpi92I9Q+zfK0hmmfLmVTguEvs4aIyELlldBb
         dzUFmF51XclYp8LgKi8Vx3tuZsMJLuneyy614=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>
	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>
	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com>
	<87ws12rh5j.fsf@macbook.be.48ers.dk> <4B1C96C4.5080709@redhat.com>
	<87hbs0mqju.fsf@macbook.be.48ers.dk>
Date: Thu, 17 Dec 2009 21:30:46 +0100
In-Reply-To: <87hbs0mqju.fsf@macbook.be.48ers.dk> (Peter Korsgaard's message
	of "Wed, 09 Dec 2009 10:42:45 +0100")
Message-ID: <87oclx4a2x.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Korsgaard <jacmet@sunsite.dk> writes:

 >>> It's probably offtopic here, but we can move the discussion to the X
 >>> list if you prefer - Last time I asked there I didn't get any reply
 >>> though:
 >>> 
 >>> http://article.gmane.org/gmane.comp.freedesktop.xorg/40071/

 Peter> Ask louder :) I think I remember your email but it got flooded
 Peter> out of my inbox. In general there should be some method to do
 Peter> that though I need to check the implementation.

 Peter> OK, great - Let me know what you find. I did hack something up
 Peter> with evtouch, but would like to move to evdev instead.

Did you find anything?

-- 
Bye, Peter Korsgaard
