Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZJ2AOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZJ2AOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZJ2AOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:14:32 -0400
Received: from maila.microsoft.com ([131.107.115.212]:26109 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZJ2AOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:14:31 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>, Milan Dadok <milan@dadok.name>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Thread-Topic: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Thread-Index: AcpYHVMYxUwscQT9TLql5bn5YWcw1QAO7S4AAADLjQAAAEGQAAAMOY7Q
Date: Thu, 29 Oct 2009 00:14:34 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E7EEC5C@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <001601ca581d$5390e0e0$fab2a2a0$@name>
 <20091028223114.GA25962@suse.de> <001701ca5821$8a52aec0$9ef80c40$@name>
 <20091028230120.GB15420@suse.de>
In-Reply-To: <20091028230120.GB15420@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> On Wed, Oct 28, 2009 at 4:01 PM, Greg KH wrote:
>>On Wed, Oct 28, 2009 at 11:54:00PM +0100, Milan Dadok wrote:
> drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
> declaration, which is probably not what you want
>
>Wierd.  Can you send me your .config file?  I can't duplicate this on
>Linus's current git tree at all.

Can you forward me your config as well Milan? I am running of Linus latest
Git tree and it works just fine without the include in osd.h. There should be
No reason to have the include in osd.h.

Thanks,

Hank.

