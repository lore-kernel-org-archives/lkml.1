Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXBTWhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXBTWhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030521AbXBTWhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:37:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:42971 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519AbXBTWhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UY1HG16E/qKrIClfzB1c1xLJEY9ML8yzZXdhreP86+WaIvkiwepo4FA01u9T+mpwWo8FLFHk0Rh3vVKF7u23bxU3DNLNIAXC1H7PmZ0v1o5KbYt7VPckMQfkpmbjERU9BwnyzHxrC0AjlP/YC02vgP4rFS94ny7GxSAZkE4/k8s=
Message-ID: <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
Date: Tue, 20 Feb 2007 23:37:36 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1172008584.25076.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 2007-02-20 at 19:54 +0100, Michal Piotrowski wrote:
> >
> > Might it be 6ba9b346e1e0eca65ec589d32de3a9fe32dc5de6 commit?
>
> I doubt that it is, but can you revert it ?

I'm using the latest kernel without this patch since 3 hours.

So far so good.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
