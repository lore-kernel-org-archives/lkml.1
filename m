Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbZIROLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbZIROLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZIROLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:11:30 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:57214 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZIROL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <20090918160944.58e5c1f5@infradead.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com> 
	<m1d45oxsrk.fsf@fess.ebiederm.org> <20090918160944.58e5c1f5@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 16:11:16 +0200
Message-ID: <ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 16:09, Arjan van de Ven <arjan@infradead.org> wrote:

> frankly, modprobe should call the settle.

We call modprobe from udev, and will have fun with such a solution.

Kay
