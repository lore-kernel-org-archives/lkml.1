Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXH1PyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXH1PyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXH1PyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:54:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:60281 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbXH1PyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Jcm2qO+XNZUJfy3njvIQHWvPExGBYROjcbHFMmAvBkLgpwTXXKfNdkDtoel88PTSVLHjgEV6Vl9kfTqBu8wawaVk7lBhUBlBjF4nnkIOG9WrNZNC0ycgyodQDuMCFDwJtPkO9JSB0kJsZgnYrdv1lXLW49h+Y5Rk/5TmySU+CXU=
Message-ID: <46D44521.9000808@gmail.com>
Date: Tue, 28 Aug 2007 17:54:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Net: ath5k, use short preamble for some rates
References: <2109718751164215004@pripojeni.net> <1188238159.7837.50.camel@johannes.berg>
In-Reply-To: <1188238159.7837.50.camel@johannes.berg>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg napsal(a):
> On Sat, 2007-08-25 at 03:58 -0400, Jiri Slaby wrote:
>> ath5k, use short preamble for some rates
>>
>> 2, 5.5 and 11 in b/g are now in short preamble mode
> 
> umm, mac80211 needs to be able to choose depending on the network.

Hmm, misleading log comment. It should be 'can now be in SP mode'.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
