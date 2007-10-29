Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbXJ2MGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbXJ2MGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXJ2MG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:06:26 -0400
Received: from rrcs-24-97-168-122.nys.biz.rr.com ([24.97.168.122]:2738 "EHLO
	mx1.ittagteam.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbXJ2MGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:06:25 -0400
From: Syd Alsobrook <syd@ittagteam.com>
Organization: IT Tag Team, Inc
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Problem: OOPS in khubd on disconnect of Labtec USB Headset
Date: Mon, 29 Oct 2007 08:05:58 -0400
User-Agent: KMail/1.8.1
References: <200710221503.54949.syd@ittagteam.com> <20071029004517.f39f867d.akpm@linux-foundation.org>
In-Reply-To: <20071029004517.f39f867d.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710290805.58741.syd@ittagteam.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (mx1.ittagteam.com [192.168.2.11]); Mon, 29 Oct 2007 08:06:07 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 03:45, you wrote:
> On Mon, 22 Oct 2007 15:03:54 -0400 Syd Alsobrook <syd@ittagteam.com> wrote:
> > OOPS in khubd on disconnect of Labtec USB Headset
> >
> > Linux version 2.6.23.1 (alsobrsp@karma) (gcc version 4.1.3 20070831
> > (prerelease) (Debian 4.1.2-16)) #5 SMP PREEMPT Sat Oct 20 11:53:38 EDT
> > 2007
>
> Did any earlier kernel work OK?  If so, can you tell us which version(s)?

This worked with the Debian packaged version of kernel 2.6.22. The specific  
package is linux-image-2.6.22-2-686 version 2.6.22-4. The problem report is 
for a custom compiled kernel.

Syd

-- 
Syd Alsobrook
IT Tag Team, Inc.
518-598-6025
http://www.ittagteam.com
