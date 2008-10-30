Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYJ3QT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYJ3QT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbYJ3QTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:19:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:8505 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbYJ3QTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q2KiNxlnyecVHcIrOqaLrZqZVv+vAeKnLo6KnOgGJ5J9vZcAPOrNz95xaziQusGrR4
         ez3SQ/8FTLdnrO11/qqFrEKljdVPMPV6Vx8iCDqct6qHLmDORFmch9Cn+ijgoqHRZqkg
         EeGygUuCiUdTsOuB6oKiADSn2SYGz/1wu9Z3M=
Message-ID: <7a6abd110810300919r3d66364fn2c0bfb1ce429f435@mail.gmail.com>
Date: Thu, 30 Oct 2008 17:19:12 +0100
From: "Jonas Bonn" <jonas.bonn@gmail.com>
To: "Alan Jenkins" <aj504@student.cs.york.ac.uk>
Subject: Re: [RFC] API for system clocks (oscillators)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4909D33B.4050108@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
	 <4909D33B.4050108@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hmm, how does this relate to the OMAP clock domain work?  I read about
> it on LWN and was impressed...
>
> omap2-clock merge: <http://thread.gmane.org/gmane.linux.ports.arm.omap/9464>
>
> Len's OLS notes: <http://lwn.net/Articles/292447/>
>

Thanks for the heads up... I will take a closer look at this.  At
first glance it appears to be on a similar path.

/Jonas
