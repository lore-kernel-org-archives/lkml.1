Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYIZW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYIZW4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYIZW4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:56:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:41515 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYIZW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HCpaSb5Xo7NE7cW8Iq1QiRvSg4DczcjZsIhfo3oiR0+JMu4x2OAe//C5GjXHxh8utG
         pePSV4Q3zkbIlHcLjHjYA+DW4SI9M02lsqk0n1x43NJqz1jb9djz0TqfSrnHSL/TaUnP
         fJhDmQQY5IoLK+bgNxD3bY/w1qNQ9USybnTAQ=
Message-ID: <48DD687E.5060703@gmail.com>
Date: Sat, 27 Sep 2008 01:55:58 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
References: <20080926215701.GC5972@tesla>
In-Reply-To: <20080926215701.GC5972@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> As part of our commitment to help support all of our Atheros devices
> under Linux we'd like to announce the release of our Atheros HAL for
> our 802.11abg chipsets under the ISC license.
> 
> You can find it here:
> 
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/legacy-hal.tar.bz2
> 
> This can be used as a source of documentation to help ath5k move
> forward to support our 802.11abg chipsets as best as possible in
> the Linux kernel. We look forward to keep working strongly with the
> community on advancing support of all our Atheros chipsets under Linux.

If I understand this correctly, madwifi is no longer a non-free driver?

Regards,
	Maxim Levitsky
