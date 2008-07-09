Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYGIP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYGIP3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYGIP3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:29:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48275 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753583AbYGIP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:29:31 -0400
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
	phones
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080708203213.GF18479@datenfreihafen.org>
References: <20080707184000.411913919@datenfreihafen.org>
	 <20080707184129.554483476@datenfreihafen.org>
	 <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com>
	 <20080707200251.GA3449@datenfreihafen.org> <48730DE2.2050302@gmail.com>
	 <4873734F.4030808@gmail.com>  <20080708203213.GF18479@datenfreihafen.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 16:29:28 +0100
Message-Id: <1215617368.4882.291.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-08 at 22:32 +0200, Stefan Schmidt wrote:

> 
> Open items we are still working on:
> o Voltage framework. Is this needed for the first merge or can we switch to it
>   with a later patch?

Hopefully the voltage framework will make the next merge window. I
received an automated message from akpm a while back saying it had been
"merged into mainline or a subsystem tree". I'm now trying to find out
why I've not seen it on linux-next atm.

Liam

