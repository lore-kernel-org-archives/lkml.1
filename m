Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbYLHXo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbYLHXo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYLHXoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:44:18 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56982 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYLHXoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:44:17 -0500
Date: Tue, 9 Dec 2008 00:44:15 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, drzeus-list@drzeus.cx, tbm@cyrius.com,
       sdhci-devel@list.drzeus.cx
Subject: Re: Is the Ricoh R5C822 documentation available?
Message-ID: <20081208234415.GA10608@hardeman.nu>
Mail-Followup-To: Frans Pop <elendil@planet.nl>,
	linux-kernel@vger.kernel.org, drzeus-list@drzeus.cx, tbm@cyrius.com,
	sdhci-devel@list.drzeus.cx
References: <20081208215458.GI14254@hardeman.nu> <200812090025.37114.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812090025.37114.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 12:25:35AM +0100, Frans Pop wrote:
Hey Frans,

>> The Ricoh R5C822 card reader in my laptop includes a smart card reader
>> (http://www.ricoh.com/LSI/product_pcif/pcc/5c821/index.html) but it
>> doesn't seem supported by the kernel.
>
>Weird. My laptop has the same device and I've successfully installed 
>Debian to it [1]...

Sorry if I was unclear. The sdhci part of the R5C822 works as expected 
(at least with a SDHC card which is the only media I've tested it with), 
it's the integrated *smart card* reader which seems unsupported and 
which I'm trying to find specs for...

-- 
David Härdeman
