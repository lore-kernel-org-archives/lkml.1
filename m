Return-Path: <linux-kernel-owner+w=401wt.eu-S1765690AbXE2U7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765690AbXE2U7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760788AbXE2U7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:59:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39558 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760701AbXE2U7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:59:04 -0400
Date: Tue, 29 May 2007 23:00:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The .paravirtprobe section is obsolete, so modpost doesn't need to handle it
Message-ID: <20070529210002.GB7738@uranus.ravnborg.org>
References: <465C8DFD.6080500@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465C8DFD.6080500@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:33:01PM -0700, Jeremy Fitzhardinge wrote:
> The .paravirtprobe section is obsolete, so modpost doesn't need to handle it.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Sam Ravnborg <sam@ravnborg.org>

Applied.

	Sam
