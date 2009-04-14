Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZDNPDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZDNPDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZDNPDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:03:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:47253 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZDNPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:03:35 -0400
Date: Tue, 14 Apr 2009 08:05:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Fast testing
Message-ID: <20090414080511.5f50a81a@infradead.org>
In-Reply-To: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
References: <2d05c4580904140255t25414b2bpe99b2a150dbe132a@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 11:55:10 +0200
Dragoslav Zaric <dragoslav.zaric.kd@gmail.com> wrote:

> Hello,
> 
> I have question regarding fast testing of some change in some kernel
> source file. Since rebooting is a long process, there must be way to

Rebooting is bloody fast for me (0.7 seconds for the kernel start,
about 3 to 4 seconds for the whole boot)....

not sure that doing weird magic to save that is worth it...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
