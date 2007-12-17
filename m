Return-Path: <linux-kernel-owner+w=401wt.eu-S934284AbXLQBQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbXLQBQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXLQBPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:15:55 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:47672 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbXLQBPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:15:54 -0500
Date: Mon, 17 Dec 2007 02:15:43 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Strange Memory Corruption Problem with Core2Duo E6700, P965
	Chipset MB and >=4GB RAM
Message-ID: <20071217011543.GA3226@citd.de>
References: <20071216013947.GA3679@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216013947.GA3679@citd.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.2007 02:39, Matthias Schniedermeyer wrote:
> Hi

It appears i found my culprit. <Knocking on wood> :-)

I have a ISDN-controller which is driven by the HFC-PCI-driver and it 
appears to not be 64bit-safe.

I will test more thorough after i have relocated the card to another 
computer.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

