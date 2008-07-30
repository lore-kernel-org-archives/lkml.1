Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYG3HOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYG3HOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYG3HOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:14:35 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:43322 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751904AbYG3HOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:14:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=CKzE9cLF616EMuRu7uvvaMfHNPky8fxDDJWg7ip+R3LV8OR/LIUhtD1Wn+NXCWDROAI+j4osdYuZBuNCe00rvMnKfX9NFMpwFAVJX6PTqtJ/yiPb6F9CjV1JIvot+17uxZjkJ46BrAvTdktVhm5SE8bxkMeZEF6cHtmzVOrdiPo=  ;
X-YMail-OSG: ttGfdk8VM1mQZXnS4c_izsoXqFvjGRbshbGGnH643oVKuRY6hrBLRI.3T5F9ngoZjjs_i2UJDmjFVdW_23uWDBGUPXoRa.55BMaaVEVvYw--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 30 Jul 2008 00:17:24 -0700
From: David Brownell <david-b@pacbell.net>
To: akpm@linux-foundation.org
Subject: Re: [RESEND x9+ patch 2.6.26-git 1/2] lm75:  cleanup and reorg
Cc: mhoffman@lightlink.com, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, khali@linux-fr.org, juergh@gmail.com
References: <200807251523.28242.david-b@pacbell.net>
 <20080729233231.0ced6d9b.akpm@linux-foundation.org>
In-Reply-To: <20080729233231.0ced6d9b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080730071724.ACADB9D3EB@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Minor cleanup and reorg of the lm75 code.
>
> This patch (and the other) have been in Mark's tree for a month or so. 
> (linux-next <- useful!)

Good to know -- thanks.  Nobody on the hwmon list seemed to know
the status when I asked, which is why I reposted.  (These have been
pending for quite a while...)


> Mark has been pretty, umm, low-key lately.  I've attached the full
> git-hwmon changelog below and the authors of all those changes are
> cc'ed.
>
> Could people please confirm that what is in linux-next is still the
> latest and greatest version of their changes?  If so, I shall plan on
> fishing those changes out of there and getting them into -rc2.

There's one more LM75 patch from Jean that's not there ...  but it
looks like those two got in just fine, so Jean's update should apply
just fine.

- Dave

