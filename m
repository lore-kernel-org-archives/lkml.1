Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219Ab0A1N4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0A1N4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192Ab0A1N4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:56:46 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57975 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0A1N4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:56:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tGA0vuVsYDoxRcqxaP01dEL4BBrzQo859S9KZBzoQfSVfqis0deljlGSurEFOJOt/b
         HmyBaEVFiFzCq6pfuwUqm8GhyoDkxzy+DeIgrd8QtwSiGtMeoF5or9BD3EgHosxwunoA
         LSvcoPQBkq7uhmGiwygQthZn4UNmQV8y0k3F8=
MIME-Version: 1.0
In-Reply-To: <4B60BE7F.8070304@gmail.com>
References: <201001152359.o0FNxVne006113@imap1.linux-foundation.org>
	 <4B5AF1E5.1070304@gmail.com>
	 <20100127142400.5657a7fe.akpm@linux-foundation.org>
	 <4B60BE7F.8070304@gmail.com>
Date: Thu, 28 Jan 2010 14:56:43 +0100
Message-ID: <8a883f731001280556p214d9b8ao6f4c4c9005825d04@mail.gmail.com>
Subject: Re: i915: gpu wedged [was: mmotm 2010-01-15-15-34 uploaded]
From: Johannes Engel <jcnengel@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to reply to all lists last time...

Looks like bug #15004 (kernel) or #25475 (Xorg).

Cheers, Johannes
