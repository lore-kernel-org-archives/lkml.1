Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZI0NYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZI0NYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 09:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZI0NYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 09:24:09 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:59967 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZI0NYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 09:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cL1e22H6vmkrXVDjfdOxSDcZ0jy8ToTSaPqEmi1VbkZ/WEnXL8i4On4ztu2evsrnzj
         Ppr441e3i3WpBgr596Ji4LN4n/DZAphrFOYr0L78pGgtqAUUKt1tjCUV5f0gEvWQF/j1
         xjF9/eXcNBh8lz477hgmR7/zVNx1H0wOeMVZQ=
MIME-Version: 1.0
In-Reply-To: <20090927151855.29efcc53@infradead.org>
References: <20090927151855.29efcc53@infradead.org>
Date: Sun, 27 Sep 2009 15:24:10 +0200
Message-ID: <8db1092f0909270624l4fc46734u6a91f7cc7ffb0c72@mail.gmail.com>
Subject: Re: [bisected] Wireless regression in 2.6.32-git
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did You have similar messages in dmesg like this:

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2089
(use WPA)
?

I try make sure, that that result of my bisection is correct.
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
