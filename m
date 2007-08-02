Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbXHBTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbXHBTZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXHBTZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:25:38 -0400
Received: from khc.piap.pl ([195.187.100.11]:44560 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbXHBTZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:25:38 -0400
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: trenn@suse.de, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org,
       Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22 regression: thermal trip points
References: <46B1988C.3090302@t-online.de>
	<1186047747.18821.450.camel@queen.suse.de>
	<46B1C0BA.1020004@t-online.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 02 Aug 2007 21:25:34 +0200
In-Reply-To: <46B1C0BA.1020004@t-online.de> (Knut Petersen's message of "Thu, 02 Aug 2007 13:32:10 +0200")
Message-ID: <m3wswdwxg1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Knut Petersen <Knut_Petersen@t-online.de> writes:

> echo "I know what I am doing" >
> /proc/acpi/thermal_zone/THRM/enable_really_dangerous_options

There is a shorter version:
$ su
Password:
# 
-- 
Krzysztof Halasa
