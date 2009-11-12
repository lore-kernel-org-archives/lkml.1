Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZKLPzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZKLPzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZKLPzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:55:51 -0500
Received: from stinky.trash.net ([213.144.137.162]:60432 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZKLPzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:55:50 -0500
Message-ID: <4AFC30D8.4050506@trash.net>
Date: Thu, 12 Nov 2009 16:59:20 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Patrick Mullaney <pmullaney@novell.com>,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arnd@arndb.de, bridge@lists.linux-foundation.org, evb@yahoogroups.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] vbus: venet macvlan support
References: <20091110222632.24100.14884.stgit@mimic.site> <4AFC2D65.9040903@gmail.com> <4AFC2F71.1060408@trash.net> <4AFC2FCC.5090103@gmail.com>
In-Reply-To: <4AFC2FCC.5090103@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Patrick McHardy wrote:
>> Gregory Haskins wrote:
>>> Patrick Mullaney wrote:
>>>> (Applies to alacrityvm.git/master:34534534)
>>>>
>>>> This patchset implements a vbus venet device with a
>>>> macvlan backend.
>>> Thanks Pat, applied.
>> As I mentioned in my response to these patches, the macvlan part
>> need more work.
> 
> Yeah, I talked to Pat offline.  He is going to patch it incrementally as
> its not a trivial problem to cleanup.  For the time being, they are
> sitting in the alacrityvm tree, but they are not going upstream until
> the macvlan stuff is resolved.

I see, thanks.
