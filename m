Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbYKXIeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbYKXIeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYKXIdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:33:49 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55485 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYKXIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:33:48 -0500
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Tomas Winkler <tomasw@gmail.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Message-Id: <3A9C0F67-8E8C-4E38-AC96-4437ED0D53DD@linux.intel.com>
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1227508394.2548.307.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: pull request: wireless-2.6 2008-11-18
Date: Mon, 24 Nov 2008 09:33:38 +0100
References: <20081119000719.GA19756@tuxdriver.com> <1ba2fa240811182246m17a6baf0ybde19af030a65819@mail.gmail.com> <1ba2fa240811190134u7974a840i532e8ed0e18f8c72@mail.gmail.com> <20081119143919.GA3485@tuxdriver.com> <1227497655.2548.257.camel@debian.sh.intel.com> <7E134DC0-A86D-460A-B5DC-22E6D9BEED92@linux.intel.com> <1227508394.2548.307.camel@debian.sh.intel.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yi,

>> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703
>>
>> and just relying on Bugzilla is not gonna be good enough. The Linux
>> kernel development has always been done via mailing lists. And while
>> there is a kernel and other Bugzillas, the main authority is still  
>> the
>> mailing list. So if you wanna get massive feedback or have testing
>> patches for debugging, then these need to be posted to linux-wireless
>> and not "hidden" into a Bugzilla.
>
> This is generally true for bugs easy to debug with. But in this  
> example,
> the first reporter opened this bug 4 months ago. People usually don't
> follow thread for such a long time. There are also some reporters  
> never
> show up in this ML.

true to some degree, but searching mailing list archives is a lot  
simpler then bug reports.

>> I do have a perfect environment in Vancouver that allows me to  
>> trigger
>> this behavior within a few minutes. So if you really wanna debug  
>> this,
>> then just send debug patches to the mailing list and I am happy to  
>> run
>> such kernels.
>
> Can you still reproduce this bug with Johannes' patch?

we will see once I am back in Vancouver. Will be some time in December  
though.

Regards

Marcel

