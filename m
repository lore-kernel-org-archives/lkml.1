Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXCMWnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXCMWnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933788AbXCMWnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:43:22 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:35221 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933791AbXCMWnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:43:21 -0400
Date: Tue, 13 Mar 2007 23:43:19 +0100
From: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
To: thomas@m3y3r.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [5/6] 2.6.21-rc3: known regressions
Message-ID: <20070313224319.GA9099@nomi.cz>
References: <1173801099.45f6c88bef4c4@213.133.104.17> <20070313155624.GA31105@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070313155624.GA31105@nomi.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 13, 2007 at 04:56:24PM +0100, Tomá¹ Janou¹ek wrote:
> On Tue, Mar 13, 2007 at 04:51:39PM +0100, thomas@m3y3r.de wrote:
> > Can you please try to compile without nohz and without hrtimers and try it
> > again?
>
> A colleage told me to try this yesterday and if I remember correctly, it did
> not help. I may try it again because I'm not sure whether it wasn't some

Ok, this was bullshit. Nohz and hrtimers turned off really solve the issue with
having to press keys.

Seems like the yesterday's check was for the other issue and I just pressed
the keys automatically, remembering that I had to.

Sorry,
-- 
Tomá¹ Janou¹ek, a.k.a. Liskni_si, http://work.lisk.in/
