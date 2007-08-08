Return-Path: <linux-kernel-owner+w=401wt.eu-S1764958AbXHHMZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764958AbXHHMZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXHHMY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:24:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:60110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbXHHMY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:24:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Date: Wed, 8 Aug 2007 14:24:49 +0200
User-Agent: KMail/1.9.6
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081424.49896.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Probably not, but this part of the code I don't fully understand.

I would suggest to defer all this until at least one example to test it 
(except vsmp which is too simple) is around.

-Andi


