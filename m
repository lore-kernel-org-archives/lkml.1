Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYH0OYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYH0OYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYH0OYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:24:32 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:46944 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYH0OYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:24:31 -0400
Date: Wed, 27 Aug 2008 16:24:06 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acer-wmi broken in latest git kernel on TravelMate 6492
 (Insufficient arguments - method [WQAA])
In-Reply-To: <20080827135418.GB7162@srcf.ucam.org>
Message-ID: <alpine.LNX.1.10.0808271623000.10895@titan.stealer.net>
References: <alpine.LNX.1.10.0808021640310.2294@titan.stealer.net> <200808021728.46046.carlos@strangeworlds.co.uk> <20080827135418.GB7162@srcf.ucam.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.3
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 27 Aug 2008 14:24:28 +0000
	Bayes: 0.1423 Tokens: new, 177; hammy, 2; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.3 SARE_SUB_OBFU_Q0 FVGT - subject contains odd letter combination
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1423]
X-Spam-Signature: f21711b7da3cd7b9641a7eb6d32db5e0b49cc981
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Matthew Garrett wrote:

> On Sat, Aug 02, 2008 at 05:28:45PM +0100, Carlos Corbacho wrote:
> > ACPI: WMI: Set instance for query block calls
> > 
> > From: Carlos Corbacho <carlos@strangeworlds.co.uk>
> > 
> > Although the necessary data structure was set up, it was never actually
> > passed in, so data block calls have only been working by sheer chance.
> 
> Hm. Has this gone upstream? Looks pretty important for .27.

Yes, it's dab36ad8d50dc9424dfc4926f62aaf9bd52dcf13.

Sven
