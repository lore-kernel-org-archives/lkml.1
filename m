Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbXHRJul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbXHRJul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXHRJuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:50:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:51043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXHRJuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:50:14 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt issue
Date: Sat, 18 Aug 2007 11:49:46 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org>
In-Reply-To: <46C637B7.30200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708181149.48217.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This patch breaks Xen booting.  

Check the latest git head. Does it still break?

-Andi
