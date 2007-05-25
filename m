Return-Path: <linux-kernel-owner+w=401wt.eu-S1764543AbXEYSDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764543AbXEYSDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763037AbXEYSDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:03:04 -0400
Received: from ns2.suse.de ([195.135.220.15]:54400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762465AbXEYSDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:03:03 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: Multiple free during oprofile unload
Date: Fri, 25 May 2007 20:02:58 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <4656FA04.5000403@redhat.com> <200705251913.53097.ak@suse.de> <20070525173813.GA2875@redhat.com>
In-Reply-To: <20070525173813.GA2875@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252002.58967.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If the functionality is completely busted in -stable,

It's not; e.g. it works great on my P4 testbox with 2.6.21

> adding a patch that's 
> isolated to that component can't really make things much worse.
> All we've done here is move the breakage.

I don't think stable is the right place for development.

-Andi

