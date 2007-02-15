Return-Path: <linux-kernel-owner+w=401wt.eu-S964816AbXBOBwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816AbXBOBwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964817AbXBOBwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:52:12 -0500
Received: from gw.goop.org ([64.81.55.164]:51720 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964816AbXBOBwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:52:10 -0500
Message-ID: <45D3BCC6.9020807@goop.org>
Date: Wed, 14 Feb 2007 17:52:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
       Ian Campbell <Ian.Campbell@XenSource.com>
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being
 booted by Xen
References: <20070213221729.772002682@goop.org>	<20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>	<45D35ABE.1050504@goop.org> <m1zm7gpkjh.fsf@ebiederm.dsl.xmission.com>	<45D3740A.4080600@goop.org> <m17iukphxr.fsf@ebiederm.dsl.xmission.com>	<45D3A5A4.7080804@goop.org> <m1ire4nqqy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ire4nqqy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Reasonable and it's probably worth letting the binutils developer know.
> I do agree that it is weird.   It might be that something in binutils
> doesn't like us dropping some of the notes.
>   

What do you mean by "dropping some of the notes"?  I think the only
notes (at least in this case) are the Xen ones, and they're all included.

    J
