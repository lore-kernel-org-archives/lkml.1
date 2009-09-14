Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbZINUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbZINUsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933670AbZINUsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:48:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:49205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbZINUsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=oV1BFgCJ9kOoGF33mlOlhiEdU2SVK3iQZq8q3mIF/PCPGlKUPph4PKG2QsmgiPgzxN
         UTy8bMcKp8ms187poAP7+DLnzLJKUfAUJoXnK4xxIcRobMsy7c5zkX8w5GwQheTjYsK9
         dddXzWxSnw8Xd6AMDu3auL+dldR1Us+cbrfY4=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Mon, 14 Sep 2009 22:48:09 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200909142015.56698.volkerarmin@googlemail.com> <200909142235.32752.oliver@neukum.org>
In-Reply-To: <200909142235.32752.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909142248.09297.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 14 September 2009, Oliver Neukum wrote:
> Am Montag, 14. September 2009 20:15:56 schrieb Volker Armin Hemmann:
> > I turned off
> > USB selective suspend/resume and wakeup
> >
> > and turned on
> > Root Hub Transaction Translators
> >  Improved Transaction Translator scheduling
> >
> > and haven't had any lockup anymore.
> >
> > Sorry for the noise. Really.
> 
> Can you please find out whether all the options you found are needed?
> 
> 	Regards
> 		Oliver
> 

sure, will do. But not tonight and I am away on Tuesday and most part of 
Wednesday.. 
I will report back on Wednesday/Thursday with some results.

Glück Auf,
Volker
