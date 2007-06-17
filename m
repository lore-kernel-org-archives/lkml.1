Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXFQNOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXFQNOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 09:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbXFQNN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 09:13:59 -0400
Received: from procserver.webwayone.co.uk ([62.8.115.202]:2188 "EHLO
	procserver.webwayone.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbXFQNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 09:13:58 -0400
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jun 2007 09:13:58 EDT
X-DKIM: Sendmail DKIM Filter v1.0.0 procserver.webwayone.co.uk l5HCpSKl006346
DomainKey-Signature: a=rsa-sha1; s=procserver; d=webwayone.co.uk; c=nofws; q=dns;
	h=x-dkim:from:to:subject:references:x-hashcash:date:
	in-reply-to:message-id:user-agent:mime-version:content-type:
	x-spam-status:x-scanned-by;
	b=hmulxvn8mZ1nR27RreweQytlGWCRm5NHke8s04fXd/ON5jTuUk2v3b39ahPmavFKY
	y1ZLe7Wxro4mzd0dlEqqw==
X-DKIM: Sendmail DKIM Filter v1.0.0 procserver.webwayone.co.uk l5HCpSKl006346
From: Graham Murray <gmurray@webwayone.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706162306.14516.dhazelton@enter.net>
	<orwsy3l0jv.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706170008.17477.dhazelton@enter.net>
X-Hashcash: 1:20:070617:linux-kernel@vger.kernel.org::cAwgSjbvk2ZQ4pe+:0000000000000000000000000000000002r6D
Date: Sun, 17 Jun 2007 13:51:28 +0100
In-Reply-To: <200706170008.17477.dhazelton@enter.net> (Daniel Hazelton's
	message of "Sun, 17 Jun 2007 00:08:17 -0400")
Message-ID: <7wabuy3fsf.fsf@gmdev.webwayone.co.uk>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.1.50 (i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:

> The second:
> I buy a DSL modem. Until I want to actually connect to the internet it can 
> have whatever settings I want it to have. The second I want to connect to the 
> internet it has to be configured the way that the ISP wants.

But only those configurations which enable it to work, such as the
modulation type, PPPOE/PPPOA, VPI/VCI, PPP username and password
etc. You still have control over the rest of the configuration such as
NAT/No NAT, LAN IP address(es), firewall, MTU, QoS, etc.
