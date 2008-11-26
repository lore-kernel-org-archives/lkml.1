Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYKZHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYKZHOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYKZHNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:13:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:46240 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZHNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:cc:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding:from;
        b=ibudBJg2TcUh8JupXDe6+HFNeULndugr00VqdlrK3aGK2rs6Mz6XFNollpbrJA0oD/
         4oXYvZMlUpHWCuLAoQLs3ER/cKMPYKfMUq9LMsior4z4NhS/zWX/ieTQfhDAdLTZ6v1N
         7dWJCOeDM6P+wPWFwtx7H2tJkoA/XTNIkRnk4=
Subject: Re: ndiswrapper 1.54-2.6.27 released
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46697.166.70.238.44.1227679338.squirrel@webmail.wolfmountaingroup.com>
References: <46697.166.70.238.44.1227679338.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 23:13:47 -0800
Message-Id: <1227683627.3145.5.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
From: "Justin P. Mattock" <justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 23:02 -0700, jmerkey@wolfmountaingroup.com wrote:
> 
> ndiswrapper with the 2.6.27 breakage corrected.  The current maintainers
> have not put out a release for 2.6.27 or later kernels, so I went ahead
> and fixed it for 2.6.27.
> 
> ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.27.7.tar.gz
> 
> Linux wireless drivers still do not work on most of my laptops and USB
> wireless devices due to lack of firmware drivers and other problems with
> native Linux wireless.  Anyone else with busted laptop wireless who need
> ndiswrapper might as well be able to get it since the maintainers have not
> posted recent releases for recent kernels.
> 
> 
> Jeff
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Cool; glad to see it working
with the latest kernel. 
BTW who is the author
of this patch?(this has baffled me for sometime);
http://www.slackware.com/~alien/slackbuilds/ndiswrapper/build/ndiswrapper_kernel_2.6.27.patch
(not to imped you in anyway);

regards;

-- 
Justin P. Mattock <Justinmattock@gmail.com>

