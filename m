Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYD0CVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYD0CVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 22:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYD0CUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 22:20:54 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:59629 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYD0CUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 22:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LyFGcOcse3L5SnI/75wzQLNgTrJJUB9x8dE5ddmnTZXG9LDKgadfBHoavevwvXch9hfn5Z2JpBbqyBP1uJ8KzkKnJkDq0IooPXMOUH+UW13bq8DJMac/4lbzxAV4sWguIiORKJWZladxoRgBUFEwUo0GzAArWgZ9FjrmJd8wkmY=
Message-ID: <dd18b0c30804261920o3bd3c7c3ud5969981f5f7d18e@mail.gmail.com>
Date: Sun, 27 Apr 2008 02:20:53 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: spinlock lockup on CPU#0
Cc: "Bernard Pidoux" <bpidoux@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <b6c5339f0804261913l4e3b6aacsa1e9db120d8fed8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262333.39383.bpidoux@free.fr>
	 <200804270215.23739.bpidoux@free.fr>
	 <dd18b0c30804261900m1a2edebld6a796e1de85c19e@mail.gmail.com>
	 <b6c5339f0804261913l4e3b6aacsa1e9db120d8fed8b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 2:13 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Apr 26, 2008 at 10:00 PM, Justin Mattock
>  <justinmattock@gmail.com> wrote:
>  >  Cool, you're welcome.
>  >  I've just pulled the latest update and rebooted, eveything looks good
>  >  except for my wireless
>
>
> >  madwifi is   giving me a *** TARGET i386-elf is invalid.
>  >  aside from that is there a patch for athk5 for the macbook's?
>
>  Heh, I guess we have the same machine.  There is some support for
>  macbooks under ath5k with the wireless-testing tree.  I'm not sure if
>  it's been merged yet.  It's also not quite there -- connections tend
>  to drop a little too often, but I have used it some.  I'm sure Nick
>  would be happy to get more traces...
>
>  --
>
>
> Bob Copeland %% www.bobcopeland.com
>

I'll have to give that a try, the number for my card is: AR5418
If there is'nt any support, then I'll have to use the ndiswrapper approach
for the time being as a quick solution, or revert to my backup kernel
regards;

-- 
Justin P. Mattock
