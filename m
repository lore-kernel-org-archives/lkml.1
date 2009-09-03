Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZICGBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZICGBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZICGBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:01:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54248 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZICGBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XH1pMNwWTJcsCei8UIiM2+cJqiigPXItfzZVHdRsd9WgJP3Otzluew1yzGjSdXxkpG
         ym4TZxlzMA5+ai/tXhcoAfBp9zOkbTjjAe62GftB584LQX5/GaTH3yIoq2ER20EB7BGk
         Hwe9Chb6MJXo5ZquupgUL2fSZe/LM+HOkfhBU=
MIME-Version: 1.0
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 09:01:32 +0300
X-Google-Sender-Auth: 6ed80f5a1df9ed05
Message-ID: <84144f020909022301pab1b36buf10e24686438e8d8@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] kmemleak: few small cleanups and clear command 
	support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: catalin.marinas@arm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Thu, Sep 3, 2009 at 8:35 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> Still not sure who this goes through so sending this to Linus.

Time zone difference alert! I'm sorry but I haven't yet figured out
how to answer my emails while I'm sleeping. :-)

Seriously though, the patches should go through Catalin's git tree
that's hiding somewhere.

                        Pekka
