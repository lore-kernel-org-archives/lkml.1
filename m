Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYGBOgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYGBOgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYGBOgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:36:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:57247 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYGBOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=f3KSIdkZU7jDJHLpsunPNwMGCy6VcKgOb41YUI1unSSKWYfufDHX2Ueblp+z99Qh4K
         Hn9a/dLbZKpxbktiQVzdUPddOoMAgNJuI2pFSQ+2tNkGz6QArT2mjhbRIJXMI8HereIc
         A7n5aHSsNpNzH0Hk3uEvUY97NNhQlKpv6p3wE=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Fix copy_user on x86
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3bq1gjsty.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8BDE.5080108@firstfloor.org>
Date: Wed, 02 Jul 2008 16:36:31 +0200
In-Reply-To: <486B8BDE.5080108@firstfloor.org> (Andi Kleen's message of "Wed,
	02 Jul 2008 16:08:30 +0200")
Message-ID: <m33amsjqts.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Haven't read the whole change, sorry. It's fairly large (perhaps split it up?)

Hmm... It will be hard to read changes in copy...unrolled routines even
in "small" chunks.

> But generally signed-off-by should be at the end of the description, not the end
> of the patch.

Thanks for guiding, I'm new here :)

-- 
wbr, Vitaly
