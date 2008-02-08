Return-Path: <linux-kernel-owner+w=401wt.eu-S934279AbYBHKSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279AbYBHKSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760366AbYBHKRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:17:55 -0500
Received: from ns.firmix.at ([62.141.48.66]:4544 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbYBHKRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:17:54 -0500
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
From: Bernd Petrovitsch <bernd@firmix.at>
To: rohit h <hrohit85@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 08 Feb 2008 11:17:41 +0100
Message-Id: <1202465861.17060.13.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.328 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.328 required=5
X-Spam-Score: -2.328 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2008-02-08 at 10:51 +0530, rohit h wrote:
> Hi,
>  I am a kernel newbie.
>  I tried to insmod a C++ module containing classes, inheritance.
>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
>  What could the problem be?

That you used C++ is the problem. Use plain C and the gcc.

>  What kind of runtime support is needed ( arm linux kernel)? Is a
> patch available for it?

Google for "linux kernel c++" and read on - this has been discussed
several times on this list.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


