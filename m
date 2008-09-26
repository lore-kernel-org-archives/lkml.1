Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYIZWCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYIZWCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYIZWCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:02:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:58268 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYIZWCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iQXpk2l1F/J1jBOUI3ndCK4yEOh29SojWP+kjqm0OBxHN8qFlBQFuZjsWTHPWX4RcD
         WjlpVqiky1U8QSM4rIvQ1iIFxpdtDtNtOszMEguDvEAzo+TeCXIxz9b01Ltt2gW8wUYj
         kv6R0U+7aPkgjP7QU8MA7hYOtYCociP7LtTgc=
Message-ID: <40f31dec0809261502o284597fwa105cb2651c74bc0@mail.gmail.com>
Date: Sat, 27 Sep 2008 01:02:43 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080926215701.GC5972@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080926215701.GC5972@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/27 Luis R. Rodriguez <lrodriguez@atheros.com>:
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
>
>  Luis

Thanks a lot for this !!!

Can't wait to get my hands dirty ;-)

I 'll start merging stuff on ath5k asap !!!


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
