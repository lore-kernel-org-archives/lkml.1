Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYFWXOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYFWXOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYFWXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:14:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:35421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYFWXOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hO0zrzTwsIalXuE5JDpWqpG+kgWX5UDEtO7gVYcHPPpukNEi6+qi5KC1mSzf4HvCtR
         Pp+a8V6DmJI34LY8ivNzDNiXgCcOnHKa09y9m0Cl431Bxn5S9BfbNsejkoklo4ImtLXi
         zNoFVsnJWqFVf2q3990eIK0K2JBvl0bnQXHGY=
Message-ID: <9929d2390806231614j66b51d01v103b7dc4efd81b38@mail.gmail.com>
Date: Mon, 23 Jun 2008 16:14:39 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RESEND PATCH 1/3] e1000e: set CONFIG_E1000E=y in x86 defconfigs
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
In-Reply-To: <20080623112618.GC7485@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622221916.5907.79563.stgit@localhost.localdomain>
	 <20080623112618.GC7485@elte.hu>
X-Google-Sender-Auth: e9c7e44215bb5fd2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 4:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
>
>> From: Auke Kok <auke-jan.h.kok@intel.com>
>>
>> This adds to the already default CONFIG_E1000=y in these files.
>>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>>
>>  arch/x86/configs/i386_defconfig   |    1 +
>>  arch/x86/configs/x86_64_defconfig |    1 +
>
> that is not an e1000 patch but an arch/x86 defconfig patch. NAK on this
> route of patch propagation.
>

So you are fine with the patch contents, just not the title/subject
line.  So if the subject line was:

[RESEND PATCH 1/3] x86 defconfig: set CONFIG_E1000E=y in x86 defconfigs

Would that have been alright?

-- 
Cheers,
Jeff
