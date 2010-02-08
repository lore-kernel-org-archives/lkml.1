Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0BHHpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:45:38 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35590 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0BHHpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:45:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RJe6SaR9SXHtXAAqpI5pYJmbT3qDHc8Gb0sVQQP45k9f7+WZBVq8iw+5Fu85bkNzAb
         aTIIDmkfWRDtlW2pRXbNd4y+xWGcLUjcGAKw4dsuRePs1VZgoBXTJkLJtZSV2mvynmvT
         mP+lwpxnHt+0HVWvX6uDt2IxvlieFWlWFuzzc=
MIME-Version: 1.0
In-Reply-To: <iuJeop2ribM.A.fyH.fY1bLB@chimera>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
	 <iuJeop2ribM.A.fyH.fY1bLB@chimera>
Date: Mon, 8 Feb 2010 08:45:34 +0100
Message-ID: <b170af451002072345x1e7666adv7f105a5f847f4d0d@mail.gmail.com>
Subject: Re: [Bug #15096] Resume lock up -- bisected, commit 
	3a1151e3f124fd1a2c54b8153f510f1a7c715369
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/8 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15096
> Subject         : Resume lock up -- bisected, commit 3a1151e3f124fd1a2c54b8153f510f1a7c715369
> Submitter       : Rafał Miłecki <zajec5@gmail.com>
> Date            : 2010-01-20 23:15 (19 days old)
> First-Bad-Commit: http://git.kernel.org/git/linus/3a1151e3f124fd1a2c54b8153f510f1a7c715369

Should be.

-- 
Rafał
