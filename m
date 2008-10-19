Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbYJSPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbYJSPyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 11:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYJSPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 11:54:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:20436 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYJSPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 11:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=JkQBLjFQTsfUmTLMWzNKxvCNXQbTcKmlFwE90Q/JAEwTml8P4xggT08JetdxXJPPHq
         sFDZkwpsMIyzufEBkjP5DJIzapsKEP4FRNCKTCULZnG10J/rAHwNK+IYiH6EFOVz+wRk
         yV66it8S+10gstgG81prm4PiqpfpNO779QC2s=
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com> <20081019040557.GA6337@goodmis.org> <70318cbf0810182334o4394f990h377b0a14215e1541@mail.gmail.com> <1224403321.13550.1.camel@unix> <70318cbf0810190117r66ddd76wc1a94a2ea79e74c5@mail.gmail.com>
Message-Id: <0FBA0BFE-2A0D-422F-A27F-ABADC56F1C04@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Chris Li <lkml@chrisli.org>
In-Reply-To: <70318cbf0810190117r66ddd76wc1a94a2ea79e74c5@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5F136)
Mime-Version: 1.0 (iPhone Mail 5F136)
Subject: Re: irq 19: nobody cared
Date: Sun, 19 Oct 2008 08:53:56 -0700
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm
I was getting the same on a mac,
What triggered this from here was
Udev and hal trying to load the iSight
Firmware at the same time,(or at least I think that's what was  
happening);

justin P. Mattock



On Oct 19, 2008, at 1:17 AM, "Chris Li" <lkml@chrisli.org> wrote:

> On Sun, Oct 19, 2008 at 1:02 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> On Sat, 2008-10-18 at 23:34 -0700, Chris Li wrote:
>>
>> What does the whole dmesg look like might I ask?
>>
> Here it is.
>
> Chris
> <dmesg-noapic.txt>
