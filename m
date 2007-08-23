Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbXHWAig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbXHWAig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbXHWAi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:38:29 -0400
Received: from gw.goop.org ([64.81.55.164]:41532 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXHWAi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:38:28 -0400
Message-ID: <46CCD707.1090009@goop.org>
Date: Wed, 22 Aug 2007 17:38:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: James Courtier-Dutton <James@superbug.demon.co.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org> <46CCB56F.8090308@superbug.co.uk> <20070822222036.GD3672@sequoia.sous-sol.org> <46CCB8BA.6060007@superbug.demon.co.uk> <46CCC361.6020600@goop.org> <20070823004700.GR2642@bingen.suse.de>
In-Reply-To: <20070823004700.GR2642@bingen.suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Aug 22, 2007 at 04:14:41PM -0700, Jeremy Fitzhardinge wrote:
>   
>> (which would also have VT, since
>> all new processors do).
>>     
>
> Not true unfortunately. The Intel low end parts like Celerons (which 
> are actually shipped in very large numbers) don't. Also Intel
> is still shipping some CPUs that don't support it at all, like
> the ULV Centrinos which are based on an older core.
>   

Likely to be missing VT-d too, right?

    J
