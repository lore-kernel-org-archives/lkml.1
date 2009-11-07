Return-Path: <linux-kernel-owner+w=401wt.eu-S1751342AbZKGKho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbZKGKho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 05:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZKGKhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 05:37:43 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:43788 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZKGKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 05:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=u3Z69YunFZzM1bpS3sDPmn9G1RAxNMWWovPgYiryNtwHxFwNiTelHRbSgrYBRCGMEe
         XdhjPaIZMRNYnLDhIwritF1p9MO7b3VY7brveTxPbi3Gk2tn6OWeOWjef8d3l9IhmxAo
         JPX0ThG3ZEGrWShac5VBmujw3DaDBRCHgzG4c=
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "ext John W. Linville" <linville@tuxdriver.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for November 2 (wireless/wl1271)
References: <20091102173845.210d1c57.sfr@canb.auug.org.au>
	<4AEF1E7F.50306@oracle.com> <20091102184449.GJ14046@tuxdriver.com>
	<20091102184843.GK14046@tuxdriver.com> <4AEF4ACB.5040302@nokia.com>
	<4AEFC7CF.1020909@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 07 Nov 2009 12:37:43 +0200
In-Reply-To: <4AEFC7CF.1020909@nokia.com> (Luciano Coelho's message of "Tue\, 03 Nov 2009 08\:03\:59 +0200")
Message-ID: <87ljiifwnc.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luciano Coelho <luciano.coelho@nokia.com> writes:

> Coelho Luciano (Nokia-D/Helsinki) wrote:
>> ext John W. Linville wrote:
>>> Helps if I actually Cc: Luca...
>>
>> Yes, it does. :) I would see this at some point but CCing me speed
>> things up quite a lot.
>
>
> BTW, I think we need this for wl1251 as well.  CC'ing Kalle too.

Thanks, but upstream wl1251 doesn't have ARP filter. There is an
internal patch but I haven't submitted it, yet.

-- 
Kalle Valo
