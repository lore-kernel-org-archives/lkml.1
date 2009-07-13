Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZGMPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZGMPkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbZGMPkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:40:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbZGMPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:40:07 -0400
Date: Mon, 13 Jul 2009 08:40:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090713084058.547e88f0@infradead.org>
In-Reply-To: <20090713151709.GA1297@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 19:47:09 +0430
Ali Gholami Rudi <ali@rudi.ir> wrote:

> Hi,
> 
> Is there any reason for not adding these ioctls to fbdev?  I searched
> the net and couldn't any.  Anyway, these patches simply implement
> those ioctls.
> 

can we turn this around, is there a reason to add them?
or in other words, how / where would these be used ?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
