Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbYGBGW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbYGBGW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758302AbYGBGWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:22:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:33428 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYGBGWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WhGSvsKRbsp+tOg4lb4sZZCERCaAEyqHr9dAg/9NTXZDZHKi58ZyM9dyumRLpDggle
         BEC/4x4kzwHtc2Oe5g5ct/AfsN6Ta13FuFfAVn3zHDp856BfHW/tApV71ntfS09NR9h3
         /G/u8avP+CN+10nA8CVxIFl4E04ehIhTSUNw4=
Message-ID: <e4c675870807012322s3937b88ak9f8b77cbe06f8e65@mail.gmail.com>
Date: Wed, 2 Jul 2008 08:22:43 +0200
From: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Subject: Re: [PATCH 3/23] make section names compatible with -ffunction-sections -fdata-sections: arm
Cc: linux-arch@vger.kernel.org, "Russell King" <rmk@arm.linux.org.uk>,
       "David Howells" <dhowells@redhat.com>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Lennert Buytenhek" <kernel@wantstofly.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>,
       "Paul Mackerras" <paulus@samba.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Andi Kleen" <andi@firstfloor.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Dave Miller" <davem@davemloft.net>
In-Reply-To: <200807020234.26755.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807020234.26755.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/2 Denys Vlasenko <vda.linux@googlemail.com>:
> The purpose of this patch is to make kernel buildable
> with "gcc -ffunction-sections -fdata-sections".
> This patch fixes arm architecture.
>

Hi Denys,

 I see your patchset. may I suggest you to take a look to this tools?

 http://www.emn.fr/x-info/coccinelle/

 I think it could simplify this kind of patching for the future.
 I found it reading the kernel janitors m-list and I hope it helps.

 Cheers,
-- 
/roberto
