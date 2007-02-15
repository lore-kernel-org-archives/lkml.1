Return-Path: <linux-kernel-owner+w=401wt.eu-S1161597AbXBOWor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161597AbXBOWor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161604AbXBOWoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:44:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:47286 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161597AbXBOWop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:44:45 -0500
Date: Thu, 15 Feb 2007 23:44:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] No need to use -traditional for processing asm in i386/kernel/
Message-ID: <20070215224439.GA7909@uranus.ravnborg.org>
References: <45D4CE50.9020604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D4CE50.9020604@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 01:19:12PM -0800, Jeremy Fitzhardinge wrote:
> No need to use -traditional for processing asm in i386/kernel/
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

Any possibility that you could 'fix' the three remaining
uses of -traditional in i386?

	Sam
