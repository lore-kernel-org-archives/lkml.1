Return-Path: <linux-kernel-owner+w=401wt.eu-S934062AbZLFRwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062AbZLFRwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbZLFRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:52:08 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:2086 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969AbZLFRwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C+ACgbDaXMJSQjSyuiGne/+HMToO55UFBXW17Gu0m5mHxVpH7yaCNrD1Y/4ONHHgDA
         oO6mzbBXkTgu5kX8uG2aErFpEApErFQHPv7Jah5oFUlrHwAzYZFVzLMTxUTxXjJ64lCK
         7ZjTPwZGGwZ+lVxXoacgXo4R0WBY7liP2O2/s=
MIME-Version: 1.0
In-Reply-To: <m3638k6lju.fsf@intrepid.localdomain>
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <1260070593.3236.6.camel@pc07.localdom.local>
	 <20091206065512.GA14651@core.coreip.homeip.net>
	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
Date: Sun, 6 Dec 2009 12:52:11 -0500
Message-ID: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 6, 2009 at 12:48 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Once again: how about agreement about the LIRC interface
> (kernel-userspace) and merging the actual LIRC code first? In-kernel
> decoding can wait a bit, it doesn't change any kernel-user interface.

I'd like to see a semi-complete design for an in-kernel IR system
before anything is merged from any source.

-- 
Jon Smirl
jonsmirl@gmail.com
