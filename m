Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYISSSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYISSSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYISSSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:18:42 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50309 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYISSSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=unxPZ/rzayyCTPE2Vtt688BS8pvszRFDOJdQkLxUhH9BlFa4SbMIv1hzlIgejXEBGo
         bGVgLCWeFv19B5NVPPQMcXesg2Jz88IjglgVOg5nFKosPCW43WW6+n9zuiEbHhd4w0cg
         v0dJQMfGLFanUDMXhenO+hnkKLzIa+p1j6zf4=
Message-ID: <dd18b0c30809191118u20a13ff3m801a23397eb6beed@mail.gmail.com>
Date: Fri, 19 Sep 2008 11:18:40 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0809191304050.2142-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809190941g8b44175haf3e3a7c354fe01c@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809191304050.2142-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 10:05 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 19 Sep 2008, Justin Mattock wrote:
>
>> The disable irq #23 message.
>>
>> As for the HC died; cleaning up
>> (where did you see that, can't seem to find that?)
>
> It's in your original message:
>
>        http://marc.info/?l=linux-kernel&m=122107367715361&w=2
>
> The line with timestamp 16.068174.
>
> Alan Stern
>
>

ahh there it is...
I've been so focused on making sure
uvcvideo is loading everything properly, I forgot to
see what happens when I load everything without
any of the uvcvideo stuff.


-- 
Justin P. Mattock
