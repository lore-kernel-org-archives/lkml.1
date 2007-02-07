Return-Path: <linux-kernel-owner+w=401wt.eu-S1422778AbXBGWFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbXBGWFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422816AbXBGWFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:05:50 -0500
Received: from terminus.zytor.com ([192.83.249.54]:50613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422778AbXBGWFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:05:50 -0500
Message-ID: <45CA4D32.6010302@zytor.com>
Date: Wed, 07 Feb 2007 14:05:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: where to maintain userspace daemon for line discipline
References: <45AE507E.3040601@imap.cc> <20070122115644.b538908f.akpm@osdl.org>
In-Reply-To: <20070122115644.b538908f.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>
>> Is there an appropriate place in or near the kernel tree for
>> stuff like that?
> 
> Nope.  The requirement arises regularly.
> 
> util-linux would seem to be a suitable place, but apparently there
> are, umm, isues surrounding that.

util-linux-ng is already going, so it's a good place.

	-hpa
