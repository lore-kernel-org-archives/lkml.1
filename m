Return-Path: <linux-kernel-owner+w=401wt.eu-S939684AbYCSWI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939684AbYCSWI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbYCSUdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:33:51 -0400
Received: from gw.goop.org ([64.81.55.164]:57341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933874AbYCSUdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:33:49 -0400
Message-ID: <47E0361B.1070907@goop.org>
Date: Tue, 18 Mar 2008 14:37:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <1205876024.28104.17.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1205876024.28104.17.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I looked over these and everything looks fine to me.  I didn't test them
> though, since I'm not working on a git tree right now, but be sure to do
> a whole slew of compile testing - those demacroizations can trip up in
> random places hidden under config options like HIGHPTE.
>   

I've been doing regular randconfig builds to shake out those kinds of 
things, though I haven't put Ingo's infrastructure in place to actually 
try to generate bootable kernels from randconfigs.

    J
