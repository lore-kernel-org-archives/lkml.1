Return-Path: <linux-kernel-owner+w=401wt.eu-S965819AbXC2AJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965819AbXC2AJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965884AbXC2AJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:09:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:32872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965819AbXC2AJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:09:10 -0400
Message-ID: <460B0399.5080904@zytor.com>
Date: Wed, 28 Mar 2007 17:08:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Paul Sokolovsky <pmiscml@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [RFC] Virtual methods for devices and generalized GPIO support
 using it
References: <881020209.20070327113610@gmail.com> <460A98B9.9040602@zytor.com> <1547009361.20070329025215@gmail.com>
In-Reply-To: <1547009361.20070329025215@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Sokolovsky wrote:
> 
>      By this criteria I happened to choose macros syntax. But it's still
> merely a syntax, and I don't pledge for it. If there's more movement
> towards using explicit low-level forms like 1) or 2) instead of
> introducing new syntactic pattern, then macro syntax can be considered
> to have fulfilled its introductory role and can be dropped.
> 

"Movement towards?!"  That's been a fundamental part of Linux design 
since the very beginning.

	-hpa
