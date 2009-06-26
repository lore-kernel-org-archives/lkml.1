Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbZFZVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbZFZVa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZFZVat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:30:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZFZVas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:30:48 -0400
Date: Fri, 26 Jun 2009 23:30:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Joseph Cihula <joseph.cihula@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090626213045.GA22359@elf.ucw.cz>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org> <20090619150514.GE1389@ucw.cz> <20090619183414.GG19771@sequoia.sous-sol.org> <alpine.LRH.2.00.0906221135550.18633@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0906221135550.18633@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Also, hardware security measures such as TXT are important in providing 
> stronger mechanisms to ensure that kernel security mechanisms are 
> functioning correctly.

I don't get it. How does TXT help kernel security mechanisms?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
