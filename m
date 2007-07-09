Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXGIGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXGIGtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXGIGtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:49:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbXGIGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EnEe7g1CSTtfUMyHdbg5Y+hVAY3ezIVDckfW3ORWIIoJKcRjW16GM7eCGzL1Ui0gts7okjyYFRCwjshZLiJoWpxGi6uCoQCmoP1iRSwUt7uZV1ARV6zJTLCvZ6yxCnjbNiPAfTMUdHEqoDWCpXfAfgjmxlhRxpDf3tvhbavDpGk=
Message-ID: <a44ae5cd0707082349i3edebef7m83d07f2b66c0afd4@mail.gmail.com>
Date: Sun, 8 Jul 2007 23:49:07 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22 -- net/core/dev.c:1515: error: 'NETIF_F_IPV6_CSUM' undeclared (first use in this function)
In-Reply-To: <a44ae5cd0707082223t50499b60m3183927750e0590e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707082223t50499b60m3183927750e0590e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nevermind.  I could not reproduce this with a clean 2.6.22 tree and
the same .config.
My previous tree must have been munged in the patching.

Sorry for the distraction,
        Miles
