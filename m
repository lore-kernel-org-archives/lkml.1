Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbYARR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbYARR6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbYARR6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:58:39 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:48812 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbYARR6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iVa7DaWgD2fo3cC/YsodIYEY/aTZMp8Wt57hH09j17ohiGFiGA+GVHhvNq56FgpdmU+XZuBeY0HhZ/jxAcL0SJzq0wNUYW+fy6U+t9+fPPKWIU1IWX0TMu3xyBr27Q7RCGJsOB5AuN/GGMk/j/aQrDyPON4BGjNzB1tQfZEhKuU=
Message-ID: <b4292e150801180958v43350590pc6ed4683bfc478ab@mail.gmail.com>
Date: Fri, 18 Jan 2008 14:58:37 -0300
From: "Adolfo R. Brandes" <arbrandes@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote Control
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
	 <Pine.LNX.4.64.0801171420400.15647@twin.jikos.cz>
	 <b4292e150801180901wfb55577kc884276622bc869e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Me:
>   I'm starting to think that these last 3 keys are broken, or maybe
> just not designed to be used as PC keys

  I decided to ask the folks at Gyration about this before tearing my
(and Jiri's) hair out, and it seems that the 3 "missing keys" are
actually not meant to send USB signals, only IR ones.  I tested it on
Windows using an usb bus tracer, and as expected (duh) nothing gets
through for them.

  Sorry about this, Jiri (although the "TV" and "Power" keys are still
broken :)!

  If I may, I'd like to add that their online support is pretty neat.
It might interest any potential buyers for this remote that they have
a partner that supposedly sells the same model with modified firmware
especially designed to work with Linux, at fiire.com.  I'm guessing
they fixed the bugginess Jiri described.

Adolfo
