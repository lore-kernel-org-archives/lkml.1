Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYHZM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYHZM6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYHZM6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:58:34 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:37314 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755884AbYHZM6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:58:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Lj/xDOLMtnk3T/zaPscDmDli57AGac4uBn7/YolMWPodFcTRfLgYh0AfUWMFiNyPk4Y+jPV6LXz6Ce7j2c/c+eddBufslPUNhvhlVCYYsGEJAtGbhIITSDgLFc70w1fOXqTqWIuesL2AhkxVEOm+P66MICi+9pWu/I+PnxuJhJo=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 26 Aug 2008 05:58:33 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <444229.17503.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Note that the hpet fix is now upstream  [...]

Any chance this can be applied to stable 2.6.26.x?

Half of my agenda was selfish (to be sure future kernels would not
hang on my 2 home servers), but the other half was to ensure that
Debian would not have hanging kernels in their next stable release.


Thanks again for all the hard work,
Dave W.
