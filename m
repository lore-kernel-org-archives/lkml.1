Return-Path: <linux-kernel-owner+w=401wt.eu-S1751437AbXBMXNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbXBMXNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXBMXNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:13:47 -0500
Received: from gw.goop.org ([64.81.55.164]:33958 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbXBMXNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:13:47 -0500
Message-ID: <45D24629.5010401@goop.org>
Date: Tue, 13 Feb 2007 15:13:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [patch 13/21] Xen-paravirt: Add nosegneg capability to the vsyscall
 page notes
References: <20070213221729.772002682@goop.org> <20070213221830.466651996@goop.org> <45D23F97.5040907@vmware.com> <45D24066.4070109@goop.org> <45D241A2.6000401@vmware.com>
In-Reply-To: <45D241A2.6000401@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I'm not super concerned either, but I still don't like it.  There
> already is dynamic replacement for vsyscall.so, so you could have just
> dropped in an an-note-ated version.

Ah, OK.  I'll have a look at that.

    J
