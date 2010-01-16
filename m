Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab0APEFy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792Ab0APEFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:05:53 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:7671 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0APEFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:05:52 -0500
Date: Fri, 15 Jan 2010 21:05:49 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/11] pci: add failed_list to record failed one for
	pci_bus_assign_resources
Message-ID: <20100116040549.GC22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please change the title of this patch to:

	pci: pbus_assign_resources_sorted now records failed insertions

> so later we can do sth with those failed one

I don't understand what "sth" means here.

thanks,
/ac
