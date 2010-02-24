Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0BXJ4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:56:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58096 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0BXJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U4R+ZZk0JvEQd6D5A2HHmzuwrl6AyRvYtNAwhfDsxcIRZLToeUUY+6sns9weobmNXl
         +Q5NP2Cjx7qw7cV+WN/psA+NdJLWSMMBdcEPn6w/T5YbM3qWFsML49BBq1Cfx7JTEYV6
         V5KsKQ/zzclvQXXfoTQ27R8iScTnzSf6cfZqI=
MIME-Version: 1.0
In-Reply-To: <4B845AEE.5080604@zytor.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
	 <4B845AEE.5080604@zytor.com>
Date: Wed, 24 Feb 2010 10:56:02 +0100
X-Google-Sender-Auth: 1184b4aa0d93f3db
Message-ID: <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder if I could ask you to recreate your patchset on top of the
> x86/asm branch in the -tip tree.

Done, resent.
