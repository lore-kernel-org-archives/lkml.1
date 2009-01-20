Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbZATJ62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbZATJ62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATJ6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:58:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:13575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZATJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:58:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tdF/Tz62ahcfeTqVnFphU7KRm8YZowCjKgC6plUuC78QiXufl0+gmNDrXYDau9fYhR
         45caVfh8fDUB+E7EumBs1+Hdw3fA3NKodWhTiRqrSWlRusZGTlU44S4kAUacsNCGwOTD
         glMs2x+7m8vVq7s09ncWEKNbSoX/paFbV6o7Y=
MIME-Version: 1.0
In-Reply-To: <cX2gZ6Cy9nC.A.06C.9JRdJB@chimera>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.06C.9JRdJB@chimera>
Date: Tue, 20 Jan 2009 10:58:15 +0100
X-Google-Sender-Auth: 26ef42597d659af0
Message-ID: <a5d587fb0901200158h860ea00gb8350ecd3927f37d@mail.gmail.com>
Subject: Re: [Bug #12393] debugging in dosemu causes lots of 'scheduling while 
	atomic'
From: Michal Suchanek <hramrach@centrum.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12393
> Subject         : debugging in dosemu causes lots of 'scheduling while atomic'
> Submitter       : Michal Suchanek <hramrach@centrum.cz>
> Date            : 2009-01-09 07:28 (11 days old)
>
>
>

See here:

http://marc.info/?l=linux-kernel&m=123188630319434&w=2

Until the patch is applied the problem will be present. It is probably
still present in 2.6.29-rc1.

Thanks

Michal
