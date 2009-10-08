Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbZJHXV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbZJHXV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757868AbZJHXV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:21:56 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:64545 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738AbZJHXVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=WWJIKeXoc2QAARz0YIQ/xDuR7y7crdtjkv0hL7nrDe73aoMpITRmIuOMhvrkUdFLfO
         UFiUpb2F4msxQa0Kn4GS5lTrhx4HjWZNo5MdudetceJT9q7kR+2Xi9dwoq14uMQwAYOd
         eZ0j3AMqs4Ht7A5KkifAx19wsWPlbN+EyYJxQ=
MIME-Version: 1.0
In-Reply-To: <f188924b0910081605i6f5cc1c3ibb4cfe6b17543521@mail.gmail.com>
References: <f188924b0910081605i6f5cc1c3ibb4cfe6b17543521@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 8 Oct 2009 19:20:58 -0400
Message-ID: <3e8340490910081620s4f259320h583b91192c4ab88e@mail.gmail.com>
Subject: Re: Microsoft is planning Windows 8 to be 128-bit
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 7:05 PM, Fred . <eldmannen@gmail.com> wrote:
> So I heard that Microsoft is now planning Windows 8 to be 128-bit.
>
> So what do guys think about this?
> And what are you going to do about it?

It's a crazy rumor. The CPU architecture would have to exist first (it
doesn't), and there's no compelling reason to go from 64-bit to
128-bit; 64-bit is a HUGE amount of address space by anyone's
standards, and we don't even have any x86-64 CPUs that can use all of
that address space yet (they're still in the 40-50 bits range). And
Microsoft isn't going to yank the rug out from under their developers
_again_ without a damn good reason.
