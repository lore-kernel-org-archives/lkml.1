Return-Path: <linux-kernel-owner+w=401wt.eu-S965138AbXCLFs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138AbXCLFs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 01:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCLFs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 01:48:59 -0400
Received: from mail16.syd.optusnet.com.au ([211.29.132.197]:58067 "EHLO
	mail16.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965138AbXCLFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 01:48:58 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
Date: Mon, 12 Mar 2007 16:48:22 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, amanda-hackers@amanda.org,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
References: <20070311013506.GD10459@waste.org> <200703111719.38514.kernel@kolivas.org> <200703120138.37667.gene.heskett@gmail.com>
In-Reply-To: <200703120138.37667.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121648.22734.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gene.

On Monday 12 March 2007 16:38, Gene Heskett wrote:
> I hate to say it Con, but this one seems to have broken the amanda-tar
> symbiosis.
>
> I haven't tried a plain 21-rc3, so the problem may exist there, and in
> fact it did for 21-rc1, but I don't recall if it was true for -rc2.  But
> I will have a plain 21-rc3 running by tomorrow nights amanda run to test.
>
> What happens is that when amanda tells tar to do a level 1 or 2, tar still
> thinks its doing a level 0.  The net result is that the tape is filled
> completely and amanda does an EOT exit in about 10 of my 42 dle's.  This
> is tar-1.15-1 for fedora core 6.

I'm sorry but I have to say I have no idea what any of this means. I gather 
you're making an association between some application combination failing and 
RSDL cpu scheduler. Unfortunately the details of what the problem is, or how 
the cpu scheduler is responsible, escape me :(

-- 
-ck
