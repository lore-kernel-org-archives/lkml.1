Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbXENGh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbXENGh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXENGhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:37:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXENGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HfbeFNgMtdwUCDcZprHIEu4MK4Got4F4UkF+2O8ZSVTXuAja6GzP0fKQKD064m6K1RssLgPjGdSGTbqmdWt+UisjRvDBIzCpq8ymsvmdK9X3GuKA27SEjg203L7kbYkZMn1pje3qr6rS100hDJnItK96Srah+UuBmU7M5QHdk8o=
Message-ID: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
Date: Mon, 14 May 2007 12:07:12 +0530
From: "Learning Linux" <learninglinux4@gmail.com>
To: kernelnewbies@nl.linux.org, linux-newbie@vger.kernel.org
Subject: Why can't we sleep in an ISR?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a very basic doubt here ... what makes it impossible to sleep
in an ISR? I mean, I know that the kernel preemption is disabled and
the kernel will panic, but I could not understand why?

TIA,

LL
