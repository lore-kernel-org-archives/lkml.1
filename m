Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZBLGh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZBLGh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZBLGhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:37:50 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:37606 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBLGht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:37:49 -0500
Subject: Re: [PATCH 6/9] Ksplice: Add functions for walking kallsyms symbols
From: Jon Masters <jonathan@jonmasters.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Jeff Arnold <jbarnold@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>
In-Reply-To: <alpine.DEB.2.00.0902111550520.27436@vinegar-pot.mit.edu>
References: <20090207124645.467A2DDDDF@ozlabs.org>
	 <1234383595.4324.42.camel@jcmlaptop>
	 <alpine.DEB.2.00.0902111550520.27436@vinegar-pot.mit.edu>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 12 Feb 2009 01:37:47 -0500
Message-Id: <1234420667.22036.26.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 01:09 -0500, Tim Abbott wrote:

> There are two different versions of the Ksplice kernel module, a 
> "standalone" version that works with an unmodified kernel, and the version 
> that we've proposed for mainline merge.

Ah thanks, I didn't realize you were proposing for mainline merge -
awesome. That would really be a useful merge...how close do you think
that is?

Jon.


