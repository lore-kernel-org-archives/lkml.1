Return-Path: <linux-kernel-owner+w=401wt.eu-S967297AbXEHABP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967297AbXEHABP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967293AbXEHABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:01:11 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:2759 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967201AbXEHABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qspM9wDQd/s+0brxjW/xK1IbE+uVs3vIQvsjUrCSc0EmwU0cVYpWzkK+PMjYndYewj0OqzeywzsOgSci2VvwWAQ2VPQPyuxH4Ek/MIgS79gYN4Ox+N3odUUhIizwCPRh/o/2/jTuPJrCRFvUr2XdsQ2+dT1fGzccIZ5BrewjTHU=
Message-ID: <463FBD8D.80208@gmail.com>
Date: Tue, 08 May 2007 04:00:13 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Markus Rechberger <mrechberger@gmail.com>,
       Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com> <4636E0E2.5020601@simon.arlott.org.uk> <Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net> <46389278.1070208@gmail.com> <Pine.LNX.4.58.0705071526170.13823@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0705071526170.13823@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:

> This is not correct.  The dvb_attach() system has no assumption that it will
> be used for a front-end device.  There are already users which are not
> front-ends, such as tuners or lnb supply control chips, 

SEC (aka Satellite Equipment Control) is a part of the frontend.

> 
> So as maintainer you are declaring that no changes of any kind are permitted?

Please do take a look at the changesets whether it is as you say.

