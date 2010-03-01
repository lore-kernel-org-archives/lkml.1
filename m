Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0CASZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:25:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0CASZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:25:39 -0500
Message-ID: <4B8C068A.4040402@zytor.com>
Date: Mon, 01 Mar 2010 10:25:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix atomic64_add_unless return value convention
References: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 09:14 AM, Luca Barbieri wrote:
> Return values 0 and 1 were swapped both in the generic implementation and
> my x86-32 one.
> 
> The x86-32 and atomic64_test.c patches should probably be squashed in the
> appropriate commits in tip/x86/atomic

We tend to be very reluctant to do that.

Anyway, please resend your patches with actual patch descriptions
(commit messages).

	-hpa
