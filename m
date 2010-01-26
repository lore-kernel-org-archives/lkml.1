Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914Ab0AZAaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab0AZAaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466Ab0AZAaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:30:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0AZAaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:30:18 -0500
Message-ID: <4B5E35DA.8010601@zytor.com>
Date: Mon, 25 Jan 2010 16:22:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gaetan Nadon <memsize@videotron.ca>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/4] x86_64 UV: Update UV arch to target Legacy VGA I/O
 correctly.
References: <20100118183412.560438000@alcatraz.americas.sgi.com>	<20100118183435.948841000@alcatraz.americas.sgi.com> <20100125155410.1fde82d4.akpm@linux-foundation.org> <4B5E31AC.3060209@sgi.com>
In-Reply-To: <4B5E31AC.3060209@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 04:05 PM, Mike Travis wrote:
>>
>> So pci_register_set_vga_state() could/should have been __init?
> 
> Good catch.  Do you want me to update and resubmit?

Please.  This patchset is still on my review queue, FWIW.

	-hpa
