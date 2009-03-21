Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZCUM2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZCUM2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCUM15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:27:57 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:43197 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZCUM14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=C3Qlzq8bUTDQqah3wHTe65bwfvO/0u5Uqk37PfmhK/IIHc4I8TgWP3r3lvyhjw1Wro
         594IDJeaNcT1BiVKw3hXuggfO266Fx6B+iUEz/UIhTD+0hkzVByMRqlgU3ePchxLPcUb
         x+0AJRnQ8Bzv6/tNYzGyQNuyF4RSNgeeWzgvE=
To: Christian Lamparter <chunkeey@web.de>
Cc: Michael Buesch <mb@bu3sch.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54: fix SoftLED compile dependencies
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
	<200903210057.47067.chunkeey@web.de> <87eiwre61a.fsf@litku.valot.fi>
	<200903211322.01654.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 21 Mar 2009 14:27:49 +0200
In-Reply-To: <200903211322.01654.chunkeey@web.de> (Christian Lamparter's message of "Sat\, 21 Mar 2009 13\:22\:01 +0100")
Message-ID: <873ad7dpru.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Lamparter <chunkeey@web.de> writes:

>> > -	  Inventel UR054G
>> > -	  Spinnaker DUT
>> 
>> This change wasn't mentioned in the commit log. Did this get included
>> by accident?
>> 
> heh true... should I add them back?

I don't know, I just wanted to point this out in case you missed it :)

> after all this list hasn't changed in years and we have a much nicer
> one on http://www.prism54.org/ (
> http://wireless.kernel.org/en/users/Drivers/p54/devices )

In my opinion wireless.kernel.org is better place for the list.

-- 
Kalle Valo
