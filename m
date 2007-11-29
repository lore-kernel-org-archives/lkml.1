Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbXK2WH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbXK2WH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933870AbXK2WHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:07:44 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:41595 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130AbXK2WHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:07:43 -0500
Date: Thu, 29 Nov 2007 23:07:05 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Li, Shaohua" <shaohua.li@intel.com>,
       linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
Message-ID: <20071129220705.GA4259@ics.muni.cz>
References: <20071127150557.GA4365@ics.muni.cz> <200711271637.13036.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEE2B3AD7@orsmsx423.amr.corp.intel.com> <1196324563.4062.15.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1196324563.4062.15.camel@yakui_zhao.sh.intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 29 Nov 2007 23:07:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 04:22:43PM +0800, Zhao Yakui wrote:
> Subject: ACPI : Delete the IRQ operation in throttling controll via PTC
> >From : Zhao Yakui <yakui.zhao@intel.com>
> 
> The IRQ operation(enable/disable) should be avoided when throttling is
> controlled via PTC method. It is replaced by the migration of task. 
> 
> Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>

works for me.

-- 
Luká¹ Hejtmánek
