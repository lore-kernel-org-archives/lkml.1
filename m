Return-Path: <linux-kernel-owner+w=401wt.eu-S937692AbZFPGKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937692AbZFPGKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936161AbZFPGBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:01:10 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:44988 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936951AbZFPGBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FpczGuan9OrSO2DSNlYefmic0UvPAbBiGBRTwKrcZoh1YSm6j1t2EqFSxGZsRsszgh
         t32zIi1PpoR82shKZ6Yq6oa7uE890VfTtx40eKDdo1+3+ifTxUzTyVlb5ysut8/ee6Wm
         O/KpQFBVMjgwKZge/iffNLiV+vZbR0+Pf0mxg=
Date: Tue, 16 Jun 2009 08:01:07 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>, akpm@linux-foundation.org
Cc: Borislav Petkov <petkovbb@googlemail.com>, Andreas Mohr <andi@lisas.de>,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] Acer Aspire One fan control resume fix,
	improvements
Message-ID: <20090616060107.GA4752@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Peter Feuerer <peter@piie.net>, akpm@linux-foundation.org,
	Borislav Petkov <petkovbb@googlemail.com>,
	Andreas Mohr <andi@lisas.de>, Len Brown <len.brown@intel.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090604211103.4214303f.peter@piie.net> <20090612143740.GA17845@rhlx01.hs-esslingen.de> <9ea470500906120837y23839a8ase31d3157f51d95cd@mail.gmail.com> <cone.1245086149.988051.6046.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1245086149.988051.6046.1000@deskpiie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Jun 15, 2009 at 07:15:49PM +0200, Peter Feuerer wrote:
> Hi Andreas, Hi Boris,
>
> I just returned from my holiday trip to italy. Thank you very much for 
> your changes. I'll merge and review them within next 2 days and send a 
> complete patch against linus-git.
>
> How long is the merge window for 2.6.31 opened? Do you think we will 
> finally get the driver merged?

the merge window opened sometime around mid last week so I think there's
plenty of time. However, it is always a good idea if the driver sees a
bit more testing by a wider audience, maybe linux-next.

Andrew, what do you think?

-- 
Regards/Gruss,
    Boris.
