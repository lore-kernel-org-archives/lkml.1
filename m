Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYLXABd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYLXABd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 19:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYLXABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 19:01:25 -0500
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:58307 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYLXABY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 19:01:24 -0500
X-Greylist: delayed 966 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2008 19:01:23 EST
Date: Tue, 23 Dec 2008 23:45:13 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: malc@pulsesoft.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lock-up on PPC64
Message-ID: <20081223234513.GA8730@deepthought>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru> <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <877i5rh9rm.fsf@linmac.oyster.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.0 c=1 a=64GYHyxuAAAA:8 a=o0sd8BUyttqqb02knLAA:9 a=Y-0Z59fk8ek6xkzLShU80B1OKjwA:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 06:04:45AM +0300, malc@pulsesoft.com wrote:
> 
> I don't know where to get PPC64 capable memtest, even if it exists the
> probability of two different machines exhibiting almost the same
> behaviour is rather slim. Netconsole doesn't catch anything. In fact
> i just had slightly different situation where after ssh connection was
> killed i was able to reconnect and look at dmesg there - nothing.
> 
 If you wanted to, you could get memtester from
http://pyropus.ca/software/memtester/ - not as convenient as
memtest86 etc (it's just a userspace task, so it can't test all the
memory), but it did work on ppc64 last time I tried it (nearly 2
years ago).

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
