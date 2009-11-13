Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZKMUhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZKMUhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZKMUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:37:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39456 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbZKMUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kumn2GZAwPxW0iqkAc3rBwfjF5x4fFkkFgnboL6WaBPsbHyZUqFJ40bsRhr+3JQdLt
         v31EfnGM7vP3s2wnNun5RWrc+6hb+WKuePu2ePyNDTOM8dEa1pYqPVXsEUcM07CbzZHB
         zYUleP7A7+DOCrb2lvBjriTxhrdrIZphq3dqw=
MIME-Version: 1.0
In-Reply-To: <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
	 <1252940549.28368.255.camel@desktop>
	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
	 <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
	 <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>
Date: Fri, 13 Nov 2009 18:37:08 -0200
Message-ID: <a4c8a6d00911131237g135df939u8c1e8ab113a481d3@mail.gmail.com>
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Thiago Farina <tfransosi@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       Andi Kleen <ak@linux.intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 6:28 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Fri, Nov 13, 2009 at 7:43 PM, Daniel Walker <dwalker@fifo99.com> wrote:
>> On Thu, 2009-11-12 at 02:23 +0200, Felipe Contreras wrote:
>>> On Mon, Sep 14, 2009 at 5:02 PM, Daniel Walker <dwalker@fifo99.com> wrote:
>>> > On Mon, 2009-09-14 at 17:34 +0300, Felipe Contreras wrote:
>>> >> I did... the style issues are already there, my patch is not
>>> >> introducing them. Do you want me to send a separate patch to fix the
>>> >> existing style issues?
>>> >
>>> > Yes, If your inclined to clean up the whole file, or just the
>>> > surrounding code that would be helpful ..
>>>
>>> Nobody seems to like the patch you suggested me to do... did I wasted
>>> my time doing it?
>>> http://article.gmane.org/gmane.linux.acpi.devel/42383
>>
>> Did you get some negative feedback ? I don't see any..
>
> Well:
> ---
> And after today's discussion on kernel summit on this topic, I wouldn't
> expect any maintainer to merge it, sorry :)
> ---
>
> That doesn't seem too positive. Or at least there's no indication that
> somebody will pick it up.

I think it is because it doesn't "aggregate" real value to the kernel
(like fixing a crash, that adds value), and the other guys has more
things to do, and don't have time to waste. But that can not be the
true, this is just my point of view.
