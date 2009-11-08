Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZKHU7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZKHU7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZKHU7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:59:53 -0500
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:56212 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZKHU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:59:52 -0500
X-Greylist: delayed 2377 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2009 15:59:52 EST
Date: Sun, 8 Nov 2009 20:19:57 +0000
From: "Emilio G. Cota" <cota@braap.org>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: Ali Gholami Rudi <ali@rudi.ir>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: What's the state of the TX timestamping?
Message-ID: <20091108201948.GA7256@braap.org>
References: <20091108155923.GA820@lilem.mirepesht> <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[dropped trivial@kernel.org since this is not relevant to them]

by the way Patrick,

A few months ago I tried to implement TX timestamping for a card
I was working on [1]. I wasn't quite successful (sorry can't be more
explicit, I haven't touched it since then) and thought the reason
was that the implementation was half-baked because David reverted
it--I got to that conclusion after reading this thread in
linux-net ("TX time stamping"):

http://thread.gmane.org/gmane.linux.network/121378/

Could you please tell me what the state of TX timestamping is?
Did David revert it or not? I can't find a revert commit.

Thanks,
		Emilio

[1] http://www.ohwr.org/twiki/bin/view/OHR/WhiteRabbit/WhiteRabbit

