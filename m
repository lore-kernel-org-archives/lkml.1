Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYFYX3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYFYX3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYFYX3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:29:10 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:37475 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYFYX3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:29:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iBG6Fg8ewVteVsdP79OzWNLn0fnNE1kDVKQkoYwu2uBDmEsyg7uVm3f322HPeW6EYo
         qI2wMRuCfa8nT1iT3KsOnDUL/s5liAVKV1JWbOJgrc3flUX+hDdqgCTpja4SvbhgiRJy
         1GWrwtDWERb50qb8Cg72eOmyPNQF0RvLj/PhM=
Message-ID: <dd18b0c30806251629q78abef79sb5b3d5a1ab17a004@mail.gmail.com>
Date: Wed, 25 Jun 2008 23:29:07 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: stuck tcp connections 2.6.26-rc7
Cc: ray-lk@madrabbit.org, didier@raboud.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080625.152447.178284093.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806241303g755e3881y4ea7d403eb2922fc@mail.gmail.com>
	 <dd18b0c30806242325j4f6d1b1bw1cdde7ea08ad12e2@mail.gmail.com>
	 <2c0942db0806250816r123affb4x4ef17f4773180a10@mail.gmail.com>
	 <20080625.152447.178284093.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 10:24 PM, David Miller <davem@davemloft.net> wrote:
> From: "Ray Lee" <ray-lk@madrabbit.org>
> Date: Wed, 25 Jun 2008 08:16:20 -0700
>
>> On my system, I've noticed that the flashplugin can manage to starve
>> other processes in a pure scheduler sort of way, so you might try
>> running latencytop to see if there's some sort of issue there. OTOH,
>> I've noticed firefox itself hang for 3-15 seconds in the middle of a
>> read (just as you describe), with nothing else going on in the system,
>> so <shrug>. I've been blaming firefox, but I could be wrong.
>
> See if firefox is stuck in disk wait when things get wedged like
> this.
>

Hello; Thanks for the response. I must admit I need to figure out how
to do that(disk wait mode with firefox).
Aside from that, it seems there are reports of this with the latest
and so forth. As a note
This explains why and when I plugged in an older kernel that had no
problems at all,
was suddenly giving me problems, leading me to believe  that my
service provider(was bandwidth limiting), or a script kiddie
was messing with the line, but this did not seem to be the case; Thankfully.
I'll look into it and let you know.
regards;

-- 
Justin P. Mattock
