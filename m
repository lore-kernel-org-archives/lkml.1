Return-Path: <linux-kernel-owner+w=401wt.eu-S935915AbXLQLIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915AbXLQLIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935453AbXLQLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:08:07 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45057 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935353AbXLQLIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:08:05 -0500
Date: Mon, 17 Dec 2007 13:08:01 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: CMD646 & cdrom: drive appears confused & drive not ready for
 command
In-Reply-To: <20071217025952.ad1017fa.akpm@linux-foundation.org>
Message-ID: <Pine.SOC.4.64.0712171306350.23091@math.ut.ee>
References: <Pine.SOC.4.64.0712162015210.27847@math.ut.ee>
 <20071217025903.cef552f1.akpm@linux-foundation.org>
 <20071217025952.ad1017fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So when did thi start?  Is 2.6.23 OK?

I have 2.6.23 running now and will see if something happens.

> > Are there any other consequences apart from log spam?

Any CD communication seems to be impossible after this starts. Will 
retest when it happens again.

-- 
Meelis Roos (mroos@linux.ee)
