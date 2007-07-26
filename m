Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXGZJqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXGZJqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXGZJqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:46:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:53680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbXGZJqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:46:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: i386-show-unhandled-signals-v3
Date: Thu, 26 Jul 2007 11:46:23 +0200
User-Agent: KMail/1.9.6
Cc: "Masoud Sharbiani" <masouds@google.com>,
       "Kirill Korotaev" <dev@openvz.org>, linux-kernel@vger.kernel.org
References: <20070718154759.GA26425@google.com> <4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com> <20070725162528.7d485ff8.akpm@linux-foundation.org>
In-Reply-To: <20070725162528.7d485ff8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261146.23886.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Look: if there's a way in which an unprivileged user can trigger a printk
> we fix it, end of story. 

I'm firmly against disabling it on x86-64 by default. The printks are extremly
useful and have found many bugs in the past.

-Andi
