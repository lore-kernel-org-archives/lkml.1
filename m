Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZBOWqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZBOWqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZBOWqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:46:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZBOWqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:46:17 -0500
Date: Sun, 15 Feb 2009 23:46:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: state of some x86 acpi patches
Message-ID: <20090215224607.GA2653@elte.hu>
References: <495C677F.6080707@goop.org> <20090102153957.GA1180@elte.hu> <4980EE0C.4070308@goop.org> <49810211.9030808@kernel.org> <498CF8DA.30004@goop.org> <498CFD95.5070004@kernel.org> <498E229C.5030205@goop.org> <20090209123711.GK17782@elte.hu> <20090215193655.GA18674@elte.hu> <499891D5.1080804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499891D5.1080804@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, i still get:

/home/mingo/tip/arch/ia64/kernel/acpi.c:203: error: conflicting types for '__acpi_unmap_table'
/home/mingo/tip/include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here
/home/mingo/tip/arch/ia64/kernel/acpi.c:203: error: conflicting types for '__acpi_unmap_table'
/home/mingo/tip/include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here

	Ingo
