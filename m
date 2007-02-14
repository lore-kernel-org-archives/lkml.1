Return-Path: <linux-kernel-owner+w=401wt.eu-S1751104AbXBNBoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbXBNBoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbXBNBoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:44:16 -0500
Received: from gw.goop.org ([64.81.55.164]:48270 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbXBNBoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:44:16 -0500
Message-ID: <45D2696D.9030706@goop.org>
Date: Tue, 13 Feb 2007 17:44:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops structure,
 do individual functions
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org> <45D260A2.4010200@vmware.com> <45D262DC.2020008@goop.org> <45D2635D.9070205@vmware.com> <45D267E8.7090506@goop.org> <45D2692D.1070505@vmware.com>
In-Reply-To: <45D2692D.1070505@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> No, it needs to be part of the general patch list first, which is
> still hand listed rather than just any op being patchable.  Then it
> can be up to the backend. 

Ah, right, yes.  We need to add all (most? some?) of the pte operations
to that list too.

    J
