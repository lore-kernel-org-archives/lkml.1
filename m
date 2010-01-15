Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0AOKIN (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692Ab0AOKIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:08:12 -0500
Received: from stinky.trash.net ([213.144.137.162]:52782 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0AOKIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:08:09 -0500
Message-ID: <4B503E86.8010603@trash.net>
Date: Fri, 15 Jan 2010 11:08:06 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        arnd@arndb.de, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] macvlan: add GRO bit to features mask
References: <20100114215058.4958.87746.stgit@mimic.site> <20100114215310.4958.46657.stgit@mimic.site>
In-Reply-To: <20100114215310.4958.46657.stgit@mimic.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Mullaney wrote:
> Allow macvlan devices to support GRO.

Acked-by: Patrick McHardy <kaber@trash.net>

Please send this patch to Dave, this can already go upstream.
