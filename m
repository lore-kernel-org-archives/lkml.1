Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZKMU2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZKMU2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbZKMU2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:28:37 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:65388 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbZKMU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZS2g54UGLOUeB4ymZs9Ibx6eQu978Sq3xFHA5EShadhyqLVxMtH51KTRZp4zgPJ1Yj
         VjUP5XwIz2hUseimxYuuCbhC5tRrMXffApMYJ5EgO1Vi5GNKdPt6GRyydte29Zqzi5r/
         dtg58YNvKWb42quHph8L5JokpSx5uemOGZreI=
MIME-Version: 1.0
In-Reply-To: <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
	 <1252940549.28368.255.camel@desktop>
	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
	 <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
Date: Fri, 13 Nov 2009 22:28:41 +0200
Message-ID: <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 7:43 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Thu, 2009-11-12 at 02:23 +0200, Felipe Contreras wrote:
>> On Mon, Sep 14, 2009 at 5:02 PM, Daniel Walker <dwalker@fifo99.com> wrote:
>> > On Mon, 2009-09-14 at 17:34 +0300, Felipe Contreras wrote:
>> >> I did... the style issues are already there, my patch is not
>> >> introducing them. Do you want me to send a separate patch to fix the
>> >> existing style issues?
>> >
>> > Yes, If your inclined to clean up the whole file, or just the
>> > surrounding code that would be helpful ..
>>
>> Nobody seems to like the patch you suggested me to do... did I wasted
>> my time doing it?
>> http://article.gmane.org/gmane.linux.acpi.devel/42383
>
> Did you get some negative feedback ? I don't see any..

Well:
---
And after today's discussion on kernel summit on this topic, I wouldn't
expect any maintainer to merge it, sorry :)
---

That doesn't seem too positive. Or at least there's no indication that
somebody will pick it up.

-- 
Felipe Contreras
