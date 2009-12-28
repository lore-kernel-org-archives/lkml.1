Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZL1XFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZL1XFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZL1XFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:05:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZL1XFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:05:42 -0500
Message-ID: <4B3939B6.7050600@zytor.com>
Date: Mon, 28 Dec 2009 15:05:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Michael Tokarev <mjt@tls.msk.ru>, Alain Knaff <alain@knaff.lu>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.33-rc1: LZMA kernel fails to decompress
References: <200912211643.18173.tvrtko.ursulin@sophos.com>	<4B2FEC10.6050900@msgid.tls.msk.ru>	<4B37AC87.1070607@knaff.lu>	<4B37C159.5080202@msgid.tls.msk.ru>	<4B390836.70100@zytor.com> <19257.11789.248634.904859@stoffel.org>
In-Reply-To: <19257.11789.248634.904859@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2009 02:15 PM, John Stoffel wrote:
> 
> Heck, even pure C code would do the trick here.
> 

C code is fine, but needs a dependency so that it is build before it is
needed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

