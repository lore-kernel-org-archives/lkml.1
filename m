Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYD0CNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYD0CNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbYD0CNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:13:37 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:24895 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758503AbYD0CNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=F0w9inc4GFwdJfuaAL/GVJNbpiE0FecmeJt4A5aNj4r1yza94VCHt8P51cuJKIsdANBHznjvLxQ3HK1Br+s+X6At3WNWym9FcVgfBqQysOS99atG6Yo5ZUiiR3GcX81fNF7Vbj+bX23dV3mm6MOQd4KEeLgRFinbI0wuBKYCgzo=
Message-ID: <b6c5339f0804261913l4e3b6aacsa1e9db120d8fed8b@mail.gmail.com>
Date: Sat, 26 Apr 2008 22:13:35 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: spinlock lockup on CPU#0
Cc: "Bernard Pidoux" <bpidoux@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <dd18b0c30804261900m1a2edebld6a796e1de85c19e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262333.39383.bpidoux@free.fr>
	 <200804270215.23739.bpidoux@free.fr>
	 <dd18b0c30804261900m1a2edebld6a796e1de85c19e@mail.gmail.com>
X-Google-Sender-Auth: 926d9c5937a383b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:00 PM, Justin Mattock
<justinmattock@gmail.com> wrote:
>  Cool, you're welcome.
>  I've just pulled the latest update and rebooted, eveything looks good
>  except for my wireless

>  madwifi is   giving me a *** TARGET i386-elf is invalid.
>  aside from that is there a patch for athk5 for the macbook's?

Heh, I guess we have the same machine.  There is some support for
macbooks under ath5k with the wireless-testing tree.  I'm not sure if
it's been merged yet.  It's also not quite there -- connections tend
to drop a little too often, but I have used it some.  I'm sure Nick
would be happy to get more traces...

-- 
Bob Copeland %% www.bobcopeland.com
