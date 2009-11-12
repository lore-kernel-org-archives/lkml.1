Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZKLPt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZKLPt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZKLPt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:49:57 -0500
Received: from stinky.trash.net ([213.144.137.162]:60299 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbZKLPt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:49:57 -0500
Message-ID: <4AFC2F71.1060408@trash.net>
Date: Thu, 12 Nov 2009 16:53:21 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Patrick Mullaney <pmullaney@novell.com>,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arnd@arndb.de, bridge@lists.linux-foundation.org, evb@yahoogroups.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] vbus: venet macvlan support
References: <20091110222632.24100.14884.stgit@mimic.site> <4AFC2D65.9040903@gmail.com>
In-Reply-To: <4AFC2D65.9040903@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Patrick Mullaney wrote:
>> (Applies to alacrityvm.git/master:34534534)
>>
>> This patchset implements a vbus venet device with a
>> macvlan backend.
> 
> Thanks Pat, applied.

As I mentioned in my response to these patches, the macvlan part
need more work.
