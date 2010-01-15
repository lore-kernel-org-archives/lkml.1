Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0AOBQ2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444Ab0AOBQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:16:27 -0500
Received: from lo.gmane.org ([80.91.229.12]:51509 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab0AOBQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:16:26 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nick Bowler <nbowler@draconx.ca>
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
Date: Fri, 15 Jan 2010 01:15:58 +0000 (UTC)
Message-ID: <hiofke$dp5$1@ger.gmane.org>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	<84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	<20100113133357.67f9df6d@jbarnes-piketon> <4B4E403C.1050509@cs.helsinki.fi>
	<20100113165530.2a7e7645@jbarnes-piketon> <4B4F6D5F.10008@cs.helsinki.fi>
	<20100114193118.GA1203@emergent.ellipticsemi.com>
	<84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	<20100114202803.GA1749@emergent.ellipticsemi.com>
	<20100114124802.025bbcae@jbarnes-piketon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpe001ee57ab26d-cm000a735d80e8.cpe.net.cable.rogers.com
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 12:48:02 -0800, Jesse Barnes wrote:
> Nick and Pekka, please try this out and reply with your Tested-by
> (assuming it works, if not I'll fix it up).

Not surprisingly, your patch solves the issues on my T500, and allows me
to re-enable the broken behaviour by adding the i915.lvds_downclock=1
boot option.

Tested-by: Nick Bowler <nbowler@elliptictech.com>

