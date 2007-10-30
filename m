Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXJ3AH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXJ3AH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXJ3AHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:07:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXJ3AHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:07:18 -0400
Message-ID: <472675AC.3070509@zytor.com>
Date: Mon, 29 Oct 2007 17:07:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
References: <20071029233231.GI7793@redhat.com>
In-Reply-To: <20071029233231.GI7793@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> Before the arch merge, I frequently would test 32bit compiles
> by doing make ARCH=i386 {bzImage/modules/file.o}
> 
> Since commit 47572387d58a9584c60ebbbdee56fc92c627f16f
> how does one do this?
> 

make ARCH=i386 {bzImage/modules/file.o}

Amazing, isn't it?

	-hpa
