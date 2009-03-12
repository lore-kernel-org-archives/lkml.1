Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZCLLju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZCLLju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZCLLjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:39:41 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:56197 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZCLLjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WUiAMrXwFtHqWHg56sgCosY0MY8kl4VUZzH4paf2b0DdqL5QiFJX95cra/XUAD56mZ
         rWAKhfUJcnlKgPPfmV3sm1lwDUVoq30nBHPIPrH5lhHhEakYVf+6PXkxG6JIO7pQJEzl
         jkVJn/IUiu7rpMAYWAHvRON17s7gSU9VjpuPM=
MIME-Version: 1.0
In-Reply-To: <20090312111443.GA20569@localhost>
References: <20090311114353.GA759@localhost> <20090311121123.GA7656@localhost>
	 <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
	 <20090311122611.GA8804@localhost>
	 <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
	 <20090312075952.GA19331@localhost>
	 <e2dc2c680903120104h4d19a3f6j57ad045bc06f9a90@mail.gmail.com>
	 <20090312081113.GA19506@localhost>
	 <e2dc2c680903120148j1aee0759td49055be059e33ae@mail.gmail.com>
	 <20090312111443.GA20569@localhost>
Date: Thu, 12 Mar 2009 12:39:36 +0100
Message-ID: <e2dc2c680903120439i73aa1db8y8e53285ddbfbb8ba@mail.gmail.com>
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

> btw, how much physical memory do you have?
> It's weird that meminfo says 1G but Mem-Info says 4G...

4 gigs.

# free -m
             total       used       free     shared    buffers     cached
Mem:          3804       1398       2405          0          1        240
-/+ buffers/cache:       1156       2648
Swap:         1992        403       1588
