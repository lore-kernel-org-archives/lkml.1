Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYKHOgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYKHOgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYKHOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:36:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:49477 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753447AbYKHOgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:36:45 -0500
X-Authenticated: #36613700
X-Provags-ID: V01U2FsdGVkX19M3fRUVmxMyR0kwGQoytAKNhVl3e2weANJtBOA5/
	Yg229seMrRKfKi
From: Mathias Schnarrenberger <mathias.schnarrenberger@gmx.de>
Reply-To: mathias.schnarrenberger@gmx.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: security: delete BIOS password in keyboard buffer during kernel bootup
Date: Sat, 8 Nov 2008 15:36:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-7-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200811081100.03966.mathias.schnarrenberger@gmx.de> <20081108142705.59c1ced7@lxorguk.ukuu.org.uk>
In-Reply-To: <20081108142705.59c1ced7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811081536.40422.mathias.schnarrenberger@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.8100000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Clear it with a program if it bothers you. You've written 90% of the
>needed code with the program below.


>Alan

Yes, I already wrote the program for my personal usage. But I wanted to share 
this information with the open source community. And I think it would be more 
secure to implement this into kernel.

Mathias
