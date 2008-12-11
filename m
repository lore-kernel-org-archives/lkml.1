Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYLKNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYLKNoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 08:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYLKNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 08:44:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:14147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYLKNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 08:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cr2UHabRxcxdzPgkGpR9CvFT4JuveDEQ69xjjrI9sY7+t1iUYxtETEfsu3nq0VKNYl
         wctor4GuN4qSanPEEv7a139eUNLHARnMZGBaQPJ7wNzXOKTOqh3w11p3VWjEXgks6QqX
         gM8yAIcZAC8lXohBgXkeQYissk0X2yECagwTg=
Message-ID: <f19298770812110544q14fd81e4o17a6430cb3bd1894@mail.gmail.com>
Date: Thu, 11 Dec 2008 16:44:28 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.28-rc8
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 04:04, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  (c) some other crazy scheme that somebody comes up with in a drug-induced
>     stupor.

Open the .29 merge window in a separate branch before making the 28 release
and merge the late-rc patches there as they come. ;)
