Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYEMLwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYEMLwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYEMLw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:52:26 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20217 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYEMLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:52:26 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 07:52:26 EDT
X-IronPort-AV: E=Sophos;i="4.27,479,1204520400"; 
   d="scan'208";a="125036"
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Tue, 13 May 2008 12:42:20 +0100
Subject: Re: [Xen-devel] Re: [PATCH] xen: remove support for non-PAE 32-bit
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: "Robert Kaiser (FH)" <kaiser@informatik.fh-wiesbaden.de>,
       <xen-devel@lists.xensource.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C44F3D2C.20A50%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH] xen: remove support for non-PAE
 32-bit
Thread-Index: Aci07mbNpV5eJiDhEd2MBgAX8io7RQ==
In-Reply-To: <200805131332.14631.kaiser@informatik.fh-wiesbaden.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 13 May 2008 11:42:33.0011 (UTC) FILETIME=[6E8E8830:01C8B4EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/5/08 12:32, "Robert Kaiser (FH)" <kaiser@informatik.fh-wiesbaden.de>
wrote:

>> applied, thanks.
> 
> Hmm, I had to revert to non-PAE operation (using xen 3.2.1) recently in order
> to get Xen to run under qemu. Does anyone know of another work-around to run
> Xen/Linux under qemu?

How does it fail? The underlying issue ought to get fixed.

 -- Keir


