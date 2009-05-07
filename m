Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbZEGCXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbZEGCXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZEGCXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:23:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:40482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZEGCXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:23:22 -0400
Date: Wed, 6 May 2009 19:25:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-ID: <20090506192538.4966c283@infradead.org>
In-Reply-To: <ac3eb2510905061908u7acbd1b2nf991aa85e1517fe4@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	<20090506184122.721c890d@infradead.org>
	<ac3eb2510905061908u7acbd1b2nf991aa85e1517fe4@mail.gmail.com>
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

On Thu, 7 May 2009 04:08:33 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> How will you solve the dynamic device numbers? They are a complete
> reality today.

not for storage though... and for the rest udev is fast enough in
practice....

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
