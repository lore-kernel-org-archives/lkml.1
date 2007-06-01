Return-Path: <linux-kernel-owner+w=401wt.eu-S1762985AbXFASs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762985AbXFASs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762103AbXFASsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:48:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54691 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761941AbXFASsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:48:50 -0400
Message-ID: <46606A0D.2040002@garzik.org>
Date: Fri, 01 Jun 2007 14:48:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>  <46599E6B.1000209@pobox.com>  <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com> <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>  <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>  <465AA536.6080608@gmail.com> <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com> <465BF244.5080200@gmail.com> <alpine.LFD.0.98.0705290924350.26602@woody.linux-foundation.org> <465F6F48.8080804@gmail.com> <alpine.LFD.0.98.0705311830360.26602@woody.linux-foundation.org> <465F8230.2040105@gmail.com> <46604E62.1000105@pobox.com> <alpine.LFD.0.98.0706010955390.3957@woody.linux-foundation.org> <466058F8.4050107@pobox.com> <alpine.LFD.0.98.0706011047000.3957@woody.linux-foundation.org> <46606851.3060905@pobox.com>
In-Reply-To: <46606851.3060905@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Upon quick review, it appears it should be 110ms.  And actually the spec 
> says 3ms.  But to answer your question anyway... :)


Actually the 3ms is the DRQ assertion delay.

	Jeff


