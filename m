Return-Path: <linux-kernel-owner+w=401wt.eu-S1761000AbXJZTFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761000AbXJZTFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJZTFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:05:47 -0400
Received: from main.gmane.org ([80.91.229.2]:40539 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXJZTFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:05:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Fri, 26 Oct 2007 21:05:33 +0200
Message-ID: <fftdpt$iqf$1@ger.gmane.org>
References: <fft89p$rko$1@ger.gmane.org> <19f34abd0710261036m65fd0d3bjace68c860a29023b@mail.gmail.com> <fftcal$dim$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c6db3.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <fftcal$dim$1@ger.gmane.org>
Cc: linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Aren't you supposed to use O= as described by "make help"?
> 
> I expect that both ways should work. I find it easier to use the environment variable
> "KBUILD_OUTPUT" because the command line parameter does not need to be repeated on each
> make invocation.

A wording correction:
I expect that both ways should work. I find it easier to use the environment variable
"KBUILD_OUTPUT" because it does not need to be repeated on each make invocation like it
must happen with the command line parameter "O=".

Regards,
Markus

