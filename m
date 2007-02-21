Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXBUUlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXBUUlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXBUUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:41:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:60446 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbXBUUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mWgnmN/rhWK4+bsCo7JaAQbpBGHRFUQfVjTtkj3TGUavYM3enrIst2b5qIpT3G2CNJd+s+m/juGc1Hdq0Mpd1D54bULXW24OAw9Pxspsf0ksRxomf/jOIWE0VUsqY6NBHHAdJzQFyj+kAIk9nT4EJmWoWyPMf9tSElzleAMgf1o=
Message-ID: <4727185d0702211241v63549a77ye1023e9ff802c24a@mail.gmail.com>
Date: Wed, 21 Feb 2007 21:41:27 +0100
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: libsata doesn't like bus without master
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I logged:
http://bugzilla.kernel.org/show_bug.cgi?id=8051

That is looking very similar to what this thread is about.

But the fact that this bites on a laptop, where you cannot
modify cabling/jumpering of the drives is annoying.

The drive is even properly recognized when booting from
a cd inserted in it. The BIOS may initialize it differently then.

-- 
Vincent Legoll
