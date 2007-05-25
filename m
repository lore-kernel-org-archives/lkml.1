Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXEYROJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXEYROJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXEYRN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:13:58 -0400
Received: from mail.suse.de ([195.135.220.2]:38203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXEYRN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:13:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: Multiple free during oprofile unload
Date: Fri, 25 May 2007 19:13:52 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <4656FA04.5000403@redhat.com> <200705251742.35692.ak@novell.com> <20070525161837.GA26105@redhat.com>
In-Reply-To: <20070525161837.GA26105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251913.53097.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> So what, the alternative is leave oprofile busted in 2.6.21.x even longer?

stable is about backporting _well tested_ patches from mainline.

If the stable request comes in from someone 5 minutes after the mainline submission
I don't see how that testing should happen. A grace period of a few days
at least is usually appropiate for normal patches (unless it's a security 
bug)

-Andi
