Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXIFFt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXIFFt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 01:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbXIFFtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 01:49:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40274 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbXIFFtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 01:49:20 -0400
Date: Thu, 6 Sep 2007 11:32:20 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Roland Dreier <rdreier@cisco.com>
cc: Bob Tracy <rct@gherkin.frus.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.23-rc5 panics
In-Reply-To: <adar6lctkq0.fsf@cisco.com>
Message-ID: <alpine.LFD.0.999.0709061127450.26804@enigma.security.iitk.ac.in>
References: <20070906052434.B7420DBA2@gherkin.frus.com>
 <adar6lctkq0.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Sep 2007, Roland Dreier wrote:

> FWIW, I was running 2.6.23-rc5 on my laptop (along with iwlwifi-0.1.14
> for wireless) and I saw the same symptom: panic (blinking capslock)
> while in X.  I saw one panic out of maybe 12 hours of uptime over a
> few reboots.  The same system is quite stable with the stock Ubuntu
> 2.6.22 kernel.
> 
> My laptop is a Thinkpad X60s (core duo) so quite a different system.
> 
> I'm traveling at the moment so I probably won't be able to gather much
> debugging info until next week.

-rc5 users should apply commit 5c127c58ae9bf196d787815b1bd6b0aec5aee816
(or else just move to latest -git).
