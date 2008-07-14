Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYGNPFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYGNPFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYGNPFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:05:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:30048 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYGNPFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nH7PfWf3XB8SaoFWGnOoq4DkL858ANhOkkAjz3BvNAj77p8WiafAA1tiUk7orKB45M
         5+UCA9SGWuE7de7lva+HaPPLpAKGC1TAR6jN4Bl+7mG2pWFLbu+lifzMWO4TWCkEvyF0
         loWsJBaC1C+fHozCRFBACXTnve4li9gOKNV+M=
Message-ID: <247d6d340807140805gfb6523en74384f6f47469d79@mail.gmail.com>
Date: Mon, 14 Jul 2008 18:05:13 +0300
From: "Guy Cohen" <guy@cguy.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080709190915.GA8238@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709190915.GA8238@tuxdriver.com>
X-Google-Sender-Auth: 942fc4136d672b57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that probably the most burning topics were a little diminished
in our agenda, and should be put higher:
- cfg80211/nl80211 - much of the current wext begins to fall behind
the emerging capabilities of the mac80211 and moreover - from future
abilities and needs of future fullmac devices. The functionality and
ABI to userspace must be finalized as soon as possible. The status of
this is very unclear and should be treated more thoroughly, and it
seems it can't be shared with 5 other topics in less than 2 hours.
- fullmac support - seems to be very relevant in the next couple of
years with the integration of wifi into low power devices running
linux.

I think that these two topics should take precedence over other topics
that although important consume more time in the agenda, and are
currently less likely to have impact on the average users such as 11s
and 11w.

it would be good if these topics will get substantial time slot in the agenda.
