Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZFFTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZFFTAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZFFTA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 15:00:26 -0400
Received: from penguin.cohaesio.net ([212.97.129.34]:35913 "EHLO
	mail.cohaesio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZFFTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 15:00:26 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jun 2009 15:00:26 EDT
Message-ID: <4A2ABB62.6080705@cohaesio.com>
Date: Sat, 06 Jun 2009 20:54:26 +0200
From: "Anders K. Pedersen" <akp@cohaesio.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.21) Gecko/20090321 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Dave McCracken <dcm@mccr.org>, linux-kernel@vger.kernel.org
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <200906041652.55298.dcm@mccr.org>
In-Reply-To: <200906041652.55298.dcm@mccr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave McCracken wrote:
> What I see as the message of his benchmark is if you care about performance 
> you should be customizing your kernel anyway.  Distro kernels are slow.  An 
> option that makes the distro kernel a bit slower is no big deal since anyone 
> who wants speed should already be rebuilding their kernel.

And Oracle of course supports customers doing that?

Not in my experience, and the same goes for most other commercial
enterprise software on Linux as well, so customers have to stick to
distro kernels, if they want support.

Regards,
Anders K. Pedersen
