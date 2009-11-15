Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZKOR1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZKOR1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 12:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZKOR1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 12:27:18 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:34773 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZKOR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 12:27:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aKFZy8Mg9l00QiVrXCGXSlosejyqm+knQrIBgJnPpLOeIdXis9UV2oezLz8kxVgjHn
         cMaGGZ1h0FjqYphZj7LvCeyWsaUVdAvgSuS1t+mz0eegVTAMKoaBpMQmMzoBpOqHeadY
         g3cTxMIDtFF7B7qBRvmzL2bLXRpYKxKeA1qLg=
MIME-Version: 1.0
In-Reply-To: <1258305351.6428.8.camel@desktop>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
	 <1252940549.28368.255.camel@desktop>
	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
	 <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
	 <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>
	 <1258305351.6428.8.camel@desktop>
Date: Sun, 15 Nov 2009 19:27:22 +0200
Message-ID: <94a0d4530911150927l3224e815ha6ff17aab6f19251@mail.gmail.com>
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

On Sun, Nov 15, 2009 at 7:15 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Fri, 2009-11-13 at 22:28 +0200, Felipe Contreras wrote:
>> That doesn't seem too positive. Or at least there's no indication that
>> somebody will pick it up.
>
> I'd re-submit with a better description of the patch. You should always
> try to describe what your doing as accurately as possible so the
> maintainer doesn't have to work very hard to know what your doing.

There's nothing to add. It's a patch to cleanup the coding style, that's it.

> That
> particular patch just has a one liner description that wasn't very
> informative .. Either that or re-submit your series without that patch
> if you don't have confidence in it.

All of my patches have been picked up, except the ones for ACPI. I
haven't received a single comment from them, which would explain the
current state of the code.

If somebody raised the hand and said; I'll merge this, please resend,
I'd do that, otherwise I think it's a waste of time.

-- 
Felipe Contreras
