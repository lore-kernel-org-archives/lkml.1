Return-Path: <linux-kernel-owner+w=401wt.eu-S1161668AbXDXGme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161668AbXDXGme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161670AbXDXGme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:42:34 -0400
Received: from [70.254.190.220] ([70.254.190.220]:46930 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161668AbXDXGmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:42:33 -0400
Date: Tue, 24 Apr 2007 06:42:33 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: NonExecutable Bit in 32Bit
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
Message-ID: <Pine.LNX.4.64.0704240640470.25153@server.thyself>
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Cestonaro, Thilo (external) wrote:

> Hey,
>
> is it right, that the NX Bit is not used under i386-Arch but under x86_64-Arch?
> When yes, is there a special argument for it not to be used?
>
> Ciao Thilo
I don't think so - some i386 cpus definitely have support for the NX bit.

Would having this be supported in i386 help debugging (and security) 
significantly?

William Heimbigner
icxcnika@mar.tar.cc
