Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXLDPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXLDPMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXLDPML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:12:11 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:54405 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXLDPMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:12:10 -0500
Message-ID: <47556E48.40703@free.fr>
Date: Tue, 04 Dec 2007 16:12:08 +0100
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Dick Johnson <linux-os@analogic.com>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Is the PCI clock within the spec?
References: <475532A7.1000408@free.fr> <20071204134254.5db8e27d@bull.net> <475555A6.3060202@free.fr> <Pine.LNX.4.61.0712040839250.8751@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712040839250.8751@chaos.analogic.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dick Johnson wrote:

> You can't just touch a scope-probe to the PCI
> clock pin and clip the scope-probe grounding
> lead to a convenient "ground" to make these
> measurements! You need a special fixture that
> will make a low-inductance connection to the
> PCI bus in the same manner as the interface chip.

(This is waaay over my head.)

Why do you think the two plots (at least the second one)
were not obtained as you describe?

Why would the system manufacturer botch the measurements
when I asked them to show me evidence that their system
was compliant?

> A scope probe will allow you to see if there is
> a clock signal. That's all. You can't determine
> its quality. A 4-inch ground lead on the scope
> probe will result in 10-20% overshoot and undershoot
> being observed.

I don't understand this 10-20% figure.
(0V + 10-20% is still 0V.)

AFAIU, the nominal peak-to-peak voltage is 3.3V. The observed
peak-to-peak voltage is 6.08V (3.3V + 84%).

Regards.
