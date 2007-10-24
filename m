Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXJXFWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXJXFWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXJXFWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:22:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:23421 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXJXFWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h5oJ5BU1dAnYceXFWf/VCv6GWxd5bwPjvDha2FkrXvajmJLn6hJc7LLcvTWF3VkYsxxzWWMq+Yu/yax0VWJF41C/VF/10dXniCmgTwwJJnYjk98/nf4ECquL6fNzqb0+rEbLyXDIE7yZzhyfaAJ7NVWMXqeKYV9LYEcY/J8lkpY=
Message-ID: <a8e1da0710232222h537be0d7tba8e654150fdd57b@mail.gmail.com>
Date: Wed, 24 Oct 2007 13:22:46 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.24-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
build failed on my pc:

arch/x86/kernel/built-in.o(.text+0x1b192): In function
`smp_send_nmi_allbutself':
: undefined reference to `genapic'

Regards
dave
