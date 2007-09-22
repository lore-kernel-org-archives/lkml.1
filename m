Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbXIVG5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbXIVG5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXIVG5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:57:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59332 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbXIVG5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:57:33 -0400
Date: Sat, 22 Sep 2007 08:59:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Message-ID: <20070922065900.GB26550@uranus.ravnborg.org>
References: <200709221231.836138000@suse.de> <20070921223218.22A8D13DCD@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921223218.22A8D13DCD@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 12:32:18AM +0200, Andi Kleen wrote:
> 
> Also allow to set svm lock.
> 
> TBD double check, documentation, i386 support
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Could we have this patch tagged with x86 instead of "Experimental" in subject.

	Sam
