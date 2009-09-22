Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZIVLk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZIVLk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZIVLk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:40:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:34164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbZIVLk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:40:28 -0400
Message-ID: <4AB8B795.4010400@kernel.org>
Date: Tue, 22 Sep 2009 20:40:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Tony Vroon <tony@linx.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	<4AB7D349.4000802@zytor.com>	<1253566046.2773.10.camel@localhost>	<4AB89417.7090005@kernel.org> <20090922112351.6b07d259@infradead.org>
In-Reply-To: <20090922112351.6b07d259@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 11:40:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> if you build with debuginfo.. run
> perl scripts/markup_oops.pl on your dmesg
> 
> that gives you not just the line, but the whole context of the crash.

Darn, I knew there gotta be something like that.  That's a pretty nice
script.  Thanks for the tip.  :-)

-- 
tejun
