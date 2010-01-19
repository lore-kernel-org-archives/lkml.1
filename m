Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448Ab0ASDFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0ASDFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 22:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710Ab0ASDFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 22:05:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab0ASDFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 22:05:20 -0500
Message-ID: <4B552171.1000001@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 11:05:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -tip 2/2] kprobetrace,	doc: Add the explanation to remove
 probe points
References: <20100117071411.GD19512@elte.hu> <20100119023512.31880.35535.stgit@localhost6.localdomain6> <4B551CE7.1000502@cn.fujitsu.com> <4B55215D.4060804@redhat.com>
In-Reply-To: <4B55215D.4060804@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Li Zefan wrote:
>> Masami Hiramatsu wrote:
>>> From: Motohiro KOSAKI <kosaki.motohiro@jp.fujitsu.com>
>>>
>>> Latest kprobetrace can remove probe points selectively. thus
>>> documentation should be updated too.
>>>
>>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
>> You should add your sob instead of ack. :)
> 
> Ah, I didn't change anything on this patch.
> Just resent :-)
> 

Still you should add your sob, since you are delivering the patch,
Andrew one reminded me on this. Also you can refer to
Documentation/SubmittingPatches:

The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path.
