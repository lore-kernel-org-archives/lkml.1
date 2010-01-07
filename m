Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830Ab0AGTbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0AGTbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738Ab0AGTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:31:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab0AGTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:31:44 -0500
Date: Thu, 7 Jan 2010 11:31:41 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       brgerst@gmail.com, hpa@zytor.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
In-Reply-To: <20100107192018.GB5460@lenovo>
Message-ID: <alpine.DEB.2.01.1001071131100.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
 <alpine.DEB.2.01.1001071101030.3483@bogon.housecafe.de> <20100107192018.GB5460@lenovo>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19KarRT0YulTcfylmeEqzBL+eLvNucD56QvpDu
 rwlbaDHR8yx07Od5rjv2/rhFx5PW9rG/BKVAO/bS+viHbvHme8
 ACq1+xAj6rr5EL0ZHeJWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 at 22:20, Cyrill Gorcunov wrote:
> for the first "guilty" commit -- it seems to be innocent, at least
> from the way how kernel_thread is converted into "C". Need time for
> more detailed review :/

OK, thanks for looking into this.

Christian.
-- 
BOFH excuse #429:

Temporal anomaly
