Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZDVOdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZDVOdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZDVOdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:33:12 -0400
Received: from intcomgrp.com ([216.54.13.120]:44573 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZDVOdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:33:11 -0400
Message-ID: <49EF2A3C.2050107@support.intcomgrp.com>
Date: Wed, 22 Apr 2009 10:31:24 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <ct38K-3Fq-11@gated-at.bofh.it> <ct38K-3Fq-9@gated-at.bofh.it> <ctmXD-1yA-3@gated-at.bofh.it> <ctnK4-2zP-11@gated-at.bofh.it> <ctoG9-458-7@gated-at.bofh.it> <ctoG9-458-5@gated-at.bofh.it> <ctoPK-4y5-5@gated-at.bofh.it> <ctoZv-4KN-23@gated-at.bofh.it> <ctFxn-5OC-11@gated-at.bofh.it> <ctG0r-6HL-31@gated-at.bofh.it>
In-Reply-To: <ctG0r-6HL-31@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Apr 22, 2009 at 10:57:37AM +0300, Mike Rapoport wrote:
> 
>> What about "line-supply"?
> 
> In power management line normally refers to the core, unregulated power
> bus for the system and a line supply would normally be something like a
> wall wart that supplies this directly when it's connected.

Can I suggest:
"supply-switch" or "regulator-switch" may make more sense for the moment.

James
