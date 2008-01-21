Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYAUWAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYAUWAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYAUWAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:00:36 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:42206 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYAUWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=P6IRDXhDDGvizXTASJCOwuBE/u//C4TSf3VtNQZTAORr+RZlm0lPUmk6mCwwM12AaMZ35jgNYuy5Pl+00oS6QMt9ZxDYuq92T7EflXxZPtzG0tI7sSIqAHtdIdL4BQmJ23+aNUqceAW5EinY1ybJczVn4Gma+x0rSNL23GcCCcs=
Message-ID: <479515FF.3050705@gmail.com>
Date: Mon, 21 Jan 2008 23:00:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?IkouIFBhYmxvIEZlcm7DoW5kZXoi?= <pupeno@pupeno.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Making a USB driver
References: <fn2u8p$gv3$1@ger.gmane.org>
In-Reply-To: <fn2u8p$gv3$1@ger.gmane.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2008 09:11 PM, J. Pablo Fernández wrote:
> Hello,
> 
> I'm interested in making a driver for the Kinesis Savant Elite Programable
> USB Foot Switches[1].

[1]+1 says
Linux, Sun and other Non Windows Platforms
· Requires available USB port. Uses generic drivers provided by the operating 
system. Due to the heterogeneity in these platforms, we cannot guarantee 
compatibility with these systems. However, if your system can use any USB mouse 
and keyboard, it will probably work with a Savant or Savant Elite foot switch.

I guess it's ordinary input device without any special driver needs.
