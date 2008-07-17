Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYGQIio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYGQIio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYGQIig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:38:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYGQIif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:38:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
In-Reply-To: Andrew Morton's message of  Thursday, 17 July 2008 01:30:13 -0700 <20080717013013.e3f7d7cf.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080717003959.edf6531c.akpm@linux-foundation.org>
	<20080717081121.DEB6015411D@magilla.localdomain>
	<20080717013013.e3f7d7cf.akpm@linux-foundation.org>
X-Shopping-List: (1) Exorbitant beef
   (2) Dietetic snowbulb ecstasy
   (3) Aerobic dubious soft-serve
   (4) Clerical circumcisions
   (5) Dogmatic blatant enemas
Message-Id: <20080717083728.C1F9015411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 01:37:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It will take some urgent effort from reviewers and, it appears, arch
> maintainers to be able to get this over the line.

All the arch considerations are opt-in, and mostly quite simple.  I
have arch patches for review by a few arch maintainers who I don't
think will mind too much.  All others can look into it at their
leisure and expect not to get broken.


Thanks,
Roland
