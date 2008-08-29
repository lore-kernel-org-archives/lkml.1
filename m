Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYH2RqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYH2RqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYH2RqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:46:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:64208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYH2RqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hUT/8837RbAKfxRECTorhpnQ8eT1eWAaAYz45Z12fDNjvxUGsktsIkcUjhWhlSMo8R
         EWzExbmFjG30vnTfXnwK0xqP8OdLYl6csA7dGm8yVFANjCZa6qaE3hzeTXqnQNdGuXNM
         hXpF3ZV4IgOwZBc5LGNmdKyiNSDqgyFKvQIZU=
Message-ID: <86802c440808291046s44dec52eh96eb5ffe4f61bc9e@mail.gmail.com>
Date: Fri, 29 Aug 2008 10:46:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <860265.84823.qm@web82105.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <860265.84823.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 7:48 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>
>
> Update:  this strangeness cannot be reproduced with a couple of reboots, so
> I'm thinking it was just bad luck that it happened while testing your patches.
>

can you check tip/master now? Ingo fixed it arlready...

YH
