Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZCLHxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZCLHxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZCLHxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:53:31 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:52873 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZCLHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ANCTPKAsaGRGbRdKtzT/iNPo7Q4kz+Qf7wVvZV5Xze3ZFSVqoKB293hn4c9nJ50kmr
         +QecdLhtoutsc0N+3XIPcFF4Cg0XtPLAKz3rhHY8qoUupfEo1CMbkYMeXvfbn2/yKjVv
         w1NSukwAuhBIszijokh9r3n26hWYK69xnQ1DI=
MIME-Version: 1.0
In-Reply-To: <20090311122611.GA8804@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
	 <20090311114353.GA759@localhost>
	 <e2dc2c680903110451m3cfa35d9s7a9fd942bcee39eb@mail.gmail.com>
	 <20090311121123.GA7656@localhost>
	 <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
	 <20090311122611.GA8804@localhost>
Date: Thu, 12 Mar 2009 08:53:27 +0100
Message-ID: <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
Subject: Re: Memory usage per memory zone
From: jack marrow <jackmarrow2@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you paste /proc/vmstat, /proc/meminfo, /proc/zoneinfo and
> /proc/slabinfo? Thank you.

Sure, but I don't know if it will help.

The oom info was from in the night, the rest is from now. I have no zoneinfo.

http://pastebin.com/m67409bc0
