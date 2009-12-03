Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZLCIrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZLCIrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZLCIrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:47:41 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:1490 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbZLCIrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:47:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAGoIF0vCTtAn/2dsb2JhbACBTtVEhDEEgWo
Date: Thu, 3 Dec 2009 09:47:42 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, grundler@parisc-linux.org, kyle@mcmartin.ca,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tulip : kernel BUG in tulip_up/tulip_resume
Message-ID: <20091203084742.GA23867@frolo.macqel>
References: <20091108223305.GA21072@frolo.macqel> <20091129001710.GA4055@ami.dom.local> <20091129113659.GA2971@ami.dom.local> <20091202.222526.237239384.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202.222526.237239384.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarek and David,
On Wed, Dec 02, 2009 at 10:25:26PM -0800, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Sun, 29 Nov 2009 12:36:59 +0100
> 
> > On Sun, Nov 29, 2009 at 01:17:10AM +0100, Jarek Poplawski wrote:
> >> Philippe De Muyter wrote, On 11/08/2009 11:33 PM:
> >> > Does someone know what could be wrong and have a fix or should I look myself ?
> >> 
> >> Don't know, guess only...
> > 
> > ...And maybe a second guess btw. (to try together or separate).
> 
> Philippe please test Jarek's patches.

Busy doing that. I had some problems trying to activate apm's debug.
Will report later.

Best regards

Philippe
