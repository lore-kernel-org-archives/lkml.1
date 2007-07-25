Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbXGYVdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbXGYVdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXGYVdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:33:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57810 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbXGYVdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:33:39 -0400
Date: Wed, 25 Jul 2007 23:34:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Nathan Lynch <ntl@pobox.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86_64 has 2 x arch_vma_name() - can we drop one?
Message-ID: <20070725213453.GC29855@uranus.ravnborg.org>
References: <20070725205959.GA29548@uranus.ravnborg.org> <20070725212321.247864D058D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725212321.247864D058D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 02:23:21PM -0700, Roland McGrath wrote:
> Your version should work, but I would do it a little differently.

Thanks, I hope to get this merged soon so we can fix Powerpc build.

	Sam
