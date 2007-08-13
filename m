Return-Path: <linux-kernel-owner+w=401wt.eu-S1030375AbXHMMQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375AbXHMMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967784AbXHMGml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:42:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:59389 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967711AbXHMGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y85aaAdbEidVwlZoZL2PtEMg3wmUc6YR63oU5ILmoVGM6shXMYE13wtUD5NWdn5CXuLYrIht8uxrRsEs0n/Vee+Rkx2ervTfpBbYJiPuDykPfntrhkeMNdn8cNRolRMuuxh0I60FgdOqkYnUeh9HNjM5DfQdJIp518b1yVjB8WY=
Message-ID: <6bffcb0e0708122342k5c1fcdd4h82486006509d2788@mail.gmail.com>
Date: Mon, 13 Aug 2007 08:42:39 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <1186984174.10249.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186984174.10249.7.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joe,

On 13/08/07, Joe Perches <joe@perches.com> wrote:
> I grew weary of looking up the appropriate
> maintainer email address(es) to CC: for a patch.
>
> I added flags to the MAINTAINERS file
>
> F:      file pattern
>
> for each maintained block and a script to parse
> the modified blocks for maintainer and list
> email addresses.
>
> perl scripts/get_maintainer.pl <patch>
>
> gives the appropriate maintainer(s).

Cool thing.

Please do not send gazzillion patches against the same file.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
