Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbYHRKbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbYHRKbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYHRKbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:31:23 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:34062 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYHRKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:31:22 -0400
In-Reply-To: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm>
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       capibara@xs4all.nl, Casey Schaufler <casey@schaufler-ca.com>,
       davecb@sun.com, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Rik van Riel <riel@redhat.com>,
       rmeijer@xs4all.nl, Theodore Tso <tytso@mit.edu>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to a linux
 interface for on access scanning (fwd)
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Mon, 18 Aug 2008 11:30:23 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 11:31:19,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 18/08/2008 11:31:19,
	Serialize complete at 18/08/2008 11:31:19,
	S/MIME Sign failed at 18/08/2008 11:31:19: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 11:30:24,
	Serialize complete at 18/08/2008 11:30:24
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818103126.3461C2FE848@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote on 18/08/2008 02:25:44:

> what is not covered by this design that is covered by the threat model 
being 
> proposed?
> 
> what did I over complicate in this design? or is it the minimum feature 
set 
> needed?
> 
> are any of the features I list impossible to implement?

One more thing - this proposal does not work where there are no extended 
attributes (whether at all or they are disabled at mount time). I think 
that is a serious flaw or at least disadvantage compared to the posted 
implementation.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

