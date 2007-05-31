Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXEaPaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXEaPaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXEaPaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:30:13 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:63364 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbXEaPaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=G4avQHM1DP/VPHKDy3VM7q/gskrHq0dhAcb+sHQJ3EhsRfTuw6C6sFl266iJGIxkya9gPJ7liYLLTCe1q57VGbJB0aVL2zoVhKiHKN6pnQ7i8ushdTl85r+O8ekoboY3DcMO01hMgZiOd1QhczD0E5CZm04eSSMtvHKsHYXatFI=
Message-ID: <465EE9F2.8080905@googlemail.com>
Date: Thu, 31 May 2007 17:29:54 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: 2.6.22-rc3-mm1
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton napisał(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> 

FYI suspend to disk doesn't work anymore on my box, system hangs after "Suspending console(s)" message.

[  186.297753] Shrinking memory...  -\|/-\|done (113064 pages freed)
[  187.841914] Freed 452256 kbytes in 1.54 seconds (293.67 MB/s)
[  187.847730] Suspending console(s)

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/mm-config

Regards,
Michal


-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
