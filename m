Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXHaOxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXHaOxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbXHaOxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:53:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6535 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbXHaOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:53:08 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: eranian@hpl.hp.com
Cc: B.Steinbrink@gmx.de, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070830210555.GA6635@frankl.hpl.hp.com>
References: <20070827225555.GI784@frankl.hpl.hp.com>
	 <1188256074.2435.272.camel@dhcp193.mvista.com>
	 <20070828091217.GA1645@frankl.hpl.hp.com>
	 <1188311684.2435.288.camel@dhcp193.mvista.com>
	 <20070828170556.GI1645@frankl.hpl.hp.com>
	 <1188325835.2435.317.camel@dhcp193.mvista.com>
	 <20070828194636.GB2814@frankl.hpl.hp.com>
	 <1188332024.2435.328.camel@dhcp193.mvista.com>
	 <20070829212451.GC4810@frankl.hpl.hp.com>
	 <1188436919.26038.27.camel@dhcp193.mvista.com>
	 <20070830210555.GA6635@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 07:43:20 -0700
Message-Id: <1188571401.26038.41.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 14:05 -0700, Stephane Eranian wrote:
> Daniel,

> Yes, I realized I missed a small detail in the switch statement.
> Could you try the new version?

This patch still has the stuck NMI .. Essentially the same thing that
happened without the patch..

Feel free to keep sending patches, I'll test them all ..

Daniel

