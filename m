Return-Path: <linux-kernel-owner+w=401wt.eu-S1751323Ab0AZRzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0AZRzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829Ab0AZRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:55:10 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48776 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323Ab0AZRzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:55:09 -0500
Message-ID: <4B5F2C6E.9010803@sgi.com>
Date: Tue, 26 Jan 2010 09:54:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
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
References: <20100118183412.560438000@alcatraz.americas.sgi.com>	<20100118183435.948841000@alcatraz.americas.sgi.com> <20100125155410.1fde82d4.akpm@linux-foundation.org> <4B5E31AC.3060209@sgi.com> <4B5E35DA.8010601@zytor.com>
In-Reply-To: <4B5E35DA.8010601@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 01/25/2010 04:05 PM, Mike Travis wrote:
>>> So pci_register_set_vga_state() could/should have been __init?
>> Good catch.  Do you want me to update and resubmit?
> 
> Please.  This patchset is still on my review queue, FWIW.
> 
> 	-hpa

Looks like Andrew added a fix-it patch to the stream.
