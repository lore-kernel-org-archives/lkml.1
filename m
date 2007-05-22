Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbXEVI7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbXEVI7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXEVI66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:58:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37010 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbXEVI65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:58:57 -0400
Message-ID: <4652B0E3.5090601@cs.helsinki.fi>
Date: Tue, 22 May 2007 11:59:15 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Nitin Gupta <nitingupta910@gmail.com>
CC: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>	 <84144f020705180342j4ff44d96iea5b73c23a69df0f@mail.gmail.com> <4cefeab80705220154k2b02a264id7774600087a80e5@mail.gmail.com>
In-Reply-To: <4cefeab80705220154k2b02a264id7774600087a80e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> What if compiler decides not to actully inline them? In that case
> there will be significant perf. hit.

Then you use __always_inline.

			Pekka
