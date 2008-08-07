Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYHGEj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYHGEj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 00:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYHGEjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 00:39:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:45514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYHGEjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 00:39:14 -0400
Date: Wed, 6 Aug 2008 21:39:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mihai =?UTF-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Cc: Adrian Bunk <bunk@kernel.org>, tvrtko.ursulin@sophos.com,
       Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080806213904.37a33a58@infradead.org>
In-Reply-To: <200808070349.55882.mdontu@bitdefender.com>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi>
	<20080806110851.C2DBC3764CE@pmx1.sophos.com>
	<20080806112646.GG6477@cs181140183.pp.htv.fi>
	<200808070349.55882.mdontu@bitdefender.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 03:49:55 +0300
Mihai Donțu <mdontu@bitdefender.com> wrote:

> Well, here is one attempt.
> 
> A good percentage of an AV product's job is to prevent exploitation
> of a security hole in a product before the vendor (assuming the
> vendor admits it's bug and not a misuse of the product's features).

just to get things clear;
you're not talking about preventing the actual exploitation per se
(that would be the job of the various protection technologies) or the
containment (that would be SELinux), but more about detecting the
presence and preventing to (accidental) use of pre-canned, widely used
exploit binaries/files ?

