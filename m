Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbXJZRhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbXJZRhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXJZRg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:36:59 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:15226 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXJZRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KOK5MgOkAfrJeswm5tVVqk8B7ZzG3roJ72Fr0LFs9tlKvSJseqQB3Qfs6QDGuw8U+0Q/cQoGGugC3nXQyIp58s7y5x6NOPd8BrifR5D3gloR21yvJI1aiJbjGTFRMHy4DMJSuhiwQD9GMJMb4D8/7bthsIU0x2jb6ztT7mshT9g=
Message-ID: <19f34abd0710261036m65fd0d3bjace68c860a29023b@mail.gmail.com>
Date: Fri, 26 Oct 2007 19:36:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Markus Elfring" <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Cc: linux-kernel@vger.kernel.org,
       "kbuild devel list" <linux-kbuild@vger.kernel.org>
In-Reply-To: <fft89p$rko$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fft89p$rko$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Markus Elfring <Markus.Elfring@web.de> wrote:
> Hello,
>
> Two ways are mentioned in the Makefile for the Linux kernel 2.6.31.1 to specify output
> diretories. The description of the environment variable "KBUILD_OUTPUT" is missing from
> the file "README".

Aren't you supposed to use O= as described by "make help"?

Vegard
