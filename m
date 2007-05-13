Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXEMSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXEMSwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXEMSwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:52:08 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:14460 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbXEMSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jO95NRCO0gyPa3S3vyuikNq3yHTLmF+BRpEMxSjW053snXzCs2YcJYCoQVh5ZbvhKrNewVo0+JpRQSNYQajqgMRDV+aweg5US40NCrEbqebbXrFxqpzL5cyfmWlIOzY5nvhrgHjpkNRIynsUiyKr8wQ5/bzP+1IwY8g2sDuGBL8=
Message-ID: <6bffcb0e0705131152y2c2035a1rf609ef818e847bb6@mail.gmail.com>
Date: Sun, 13 May 2007 20:52:04 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       "Jean Delvare" <khali@linux-fr.org>,
       "Antonino Ingargiola" <tritemio@gmail.com>, linux-ide@vger.kernel.org,
       "Paul Mundt" <lethal@linux-sh.org>, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>, linux-fsdevel@vger.kernel.org,
       xfs-masters@oss.sgi.com, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "David Chinner" <dgc@sgi.com>, "Charles Gagalac" <charle97@yahoo.com>
In-Reply-To: <Pine.LNX.4.64.0705131118160.3212@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46475595.4050105@googlemail.com>
	 <Pine.LNX.4.64.0705131118160.3212@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Sun, 13 May 2007, Michal Piotrowski wrote:
>
> > Subject    : applications under wine freezes
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8462
> > Submitter  : Charles Gagalac <charle97@yahoo.com>
> > Caused-By  : Davide Libenzi <davidel@xmailserver.org>
> >              commit 6192bd536f96c6a0d969081bc71ae24f9319bfdc
> > Handled-By : Davide Libenzi <davidel@xmailserver.org>
> > Status     : problem is being debugged
>
> This has been fixed. Confirmed by myself and Charles Gagalac. Patches have
> been sent to Andrew.

Bugzilla is back. Did you mean this patch
http://bugzilla.kernel.org/show_bug.cgi?id=8462#c8 ?

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
