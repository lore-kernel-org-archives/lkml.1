Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0BNTH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:07:59 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:60169 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0BNTH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m6Zae3TW3nAEhHT6IM47buLbWgq9gKB9itld8eiP6IVLARUMSaeu6TKfPAh3KbfW4i
         mcnsCW+chL3f5TDCYiU4D8I5og2rqrhkNJlni7uKxHnL1AA9VyaL001s6BoctEjS4olD
         cAMiEQSm5i0C5UDcu/G4a0GZix/OiKnaiHi6g=
MIME-Version: 1.0
In-Reply-To: <20100214190431.GA28842@srcf.ucam.org>
References: <1266144897-2681-1-git-send-email-erik.andren@gmail.com>
	 <20100214165528.GA25624@srcf.ucam.org>
	 <62e5edd41002141059k5e06fc5o91b06e389d9609e3@mail.gmail.com>
	 <20100214190431.GA28842@srcf.ucam.org>
Date: Sun, 14 Feb 2010 20:07:56 +0100
Message-ID: <62e5edd41002141107n787920f0p15fd91add5eee5be@mail.gmail.com>
Subject: Re: [PATCH 1/1] platform/x86/dell-laptop: Add another Dell laptop to 
	the DMI whitelist
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/14 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Sun, Feb 14, 2010 at 07:59:06PM +0100, Erik Andrén wrote:
>
>> Darn, I forgot to add another module alias.
>> Shall I respin the whole patch or create another one depending on the old one?
>
> Oh, good point! I can add that myself and merge it in.
>

Thanks!
FWIW I've verified that the following string works:
MODULE_ALIAS("dmi:*svnDellComputerCorporation:*:ct8:*");

Best regards,
Erik

> --
> Matthew Garrett | mjg59@srcf.ucam.org
>
