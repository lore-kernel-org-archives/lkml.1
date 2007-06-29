Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXF2LWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXF2LWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbXF2LWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 07:22:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:12514 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830AbXF2LWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 07:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S9IFPkiD7FmR8CryRRELVYC25Ojx+zbpcoVCTmzxlPgydXYANgZh45R7umowbLwzSwitVnexLER+nS22n34sMfOKxac3brz0PLSiB1QpPw+AkCfL9q/1KZoazywZimIzJabZP3gtKI2FzAWe2JHcWz2KY1lcV1qoPYvfoRRoicI=
Message-ID: <4dde4acb0706290422j1848d5ach3ab60188618f8dab@mail.gmail.com>
Date: Fri, 29 Jun 2007 16:52:05 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: Fwd: Mounting MMC card
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org, maraz@ics.forth.gr
In-Reply-To: <4684E8C2.7050109@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <4684CDCC.9030202@drzeus.cx>
	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
	 <4684D358.9090402@drzeus.cx>
	 <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
	 <4684DEF3.5060103@drzeus.cx>
	 <4dde4acb0706290357x54d3ea32vaf75d5cfe638cb25@mail.gmail.com>
	 <4684E65F.2070202@drzeus.cx>
	 <4dde4acb0706290406v204fb87eif0e5fbae17636593@mail.gmail.com>
	 <4684E8C2.7050109@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Then something is seriously broken with your kernel. I can only assume that this
> is because of some vendor modifications. So I would suggest contacting them or
> trying to get a vanilla kernel running.

    Hmm. I will try getting the vanilla kernel and putting the
required patches. Or rather see what can be done with this driver.
Thanks a lot for all the help.


Thanks,
Midhun.
