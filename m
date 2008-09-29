Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYI2ADw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYI2ADw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 20:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYI2ADp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 20:03:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYI2ADp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 20:03:45 -0400
Message-ID: <48E01B0A.2060204@kernel.org>
Date: Mon, 29 Sep 2008 09:02:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: Linux-IDE <linux-ide@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata flooding syslog
References: <20080915100909.79c1d67b@werewolf.home> <20080919001834.31a3f8f9@werewolf.home>
In-Reply-To: <20080919001834.31a3f8f9@werewolf.home>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Sep 2008 00:03:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi,
> 
> Any idea about this ?
> I have seen it also on ubuntu and arch lists...

Sorry about the delay.  I've been traveling for quite some time.  The
bug is being tracked via the following bugzilla bug and patch has been
posted.

  http://bugzilla.kernel.org/show_bug.cgi?id=11615

Thanks.

-- 
tejun
