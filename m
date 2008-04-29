Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbYD2NiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbYD2NiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbYD2Nhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:37:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYD2Nhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PmMNex10eYj6tddJlJNoDfnWfQEO5cb++la4J8rMXwJwgEIxoqhEAfTiI2AekTWBc+tYh5gZ40ibCGZPFBRx7FK33iDgIsLe6x19BGVhPX4vrPx1U88IaIif/MmhXD4fyMbzFCHIyl86vqs0fURrOoATnHVmIpV1lxtJgDlNEY8=
Date: Tue, 29 Apr 2008 17:36:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
Message-ID: <20080429133658.GA6837@cvg>
References: <20080424144120.GA7717@cvg> <4810CC2F.3010600@zytor.com> <20080428182323.GD1685@elte.hu> <20080428192039.GA10267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428192039.GA10267@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Apr 28, 2008 at 09:20:39PM +0200]
| 
| Cyrill,
| 
| randconfig testing in x86.git found a build bug and i bisected it to 
| your patch - output is below. Config attached. Looks like some config 
| file dependency hell problem? The dependencies there definitely need a 
| good look and a handful of cleanups as well.
| 
| 	Ingo
| 
[...]

Oh, Ingo, really sorry...
Give me some time to handle it.

		- Cyrill -
