Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbYC0KFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbYC0KFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYC0KE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:04:57 -0400
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:22209 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756593AbYC0KE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:04:57 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 06:04:57 EDT
From: Amit Shah <amit.shah@qumranet.com>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: [PATCH 0/20] dma_ops for i386
Date: Thu, 27 Mar 2008 15:19:44 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       "Avi Kivity" <avi@qumranet.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
In-Reply-To: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271519.44871.amit.shah@qumranet.com>
X-OriginalArrivalTime: 27 Mar 2008 09:49:46.0600 (UTC) FILETIME=[E40BE680:01C88FEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* On Wednesday 26 March 2008 03:06:19 Glauber Costa wrote:
> Hello,
>
> Here there is a series of 20 patches that lays the foundations for
> using dma_ops in i386 in the very same way x86_64, as well as many other
> architectures already do.

Thanks; Please also see Stephen Tweedie's tree at

http://git.et.redhat.com/?p=linux-2.6-dom0-pvops.git;a=summary

I guess your work would be overlapped anyway, but just to make sure there's no 
double work.
