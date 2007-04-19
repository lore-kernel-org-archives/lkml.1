Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXDSUvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXDSUvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXDSUvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:51:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:56385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXDSUvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:51:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
Date: Thu, 19 Apr 2007 22:50:52 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070414204154.871250608@goop.org> <20070414204924.125386443@goop.org> <4627D57C.4070809@redhat.com>
In-Reply-To: <4627D57C.4070809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704192250.52633.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Is some version of this going in for 2.6.21, or is it not a real problem?

When it's only seen with Xen it's not a real problem right now.

-Andi


