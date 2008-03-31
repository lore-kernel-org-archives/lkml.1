Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYCaNAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYCaNAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYCaNAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:00:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34479 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYCaNAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:00:44 -0400
Message-ID: <47F0E05E.6060200@s5r6.in-berlin.de>
Date: Mon, 31 Mar 2008 15:00:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Michlmayr <tbm@cyrius.com>, Jarod Wilson <jwilson@redhat.com>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
References: <20080321153952.GA26354@deprecation.cyrius.com> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <200803302106.42624.jwilson@redhat.com> <alpine.LFD.1.10.0803311217550.3219@apollo.tec.linutronix.de> <20080331102852.GJ28821@deprecation.cyrius.com> <47F0E00E.30200@s5r6.in-berlin.de>
In-Reply-To: <47F0E00E.30200@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> I can confirm that what Martin previously posted in this thread shows
> that firewire-ohci + firewire-core and ohci1394 + ieee1394 fail in the
> same way

...by looking at his dmesg's.  I don't have affected hardware myself.
-- 
Stefan Richter
-=====-==--- --== =====
http://arcgraph.de/sr/
