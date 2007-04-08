Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbXDHGTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbXDHGTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 02:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXDHGTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 02:19:39 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:17784 "EHLO
	asav17.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXDHGTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 02:19:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPQlGEZKhRO4UGdsb2JhbACPeQEBGyM
From: Dmitry Torokhov <dtor@insightbb.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Sun, 8 Apr 2007 02:19:38 -0400
User-Agent: KMail/1.9.3
Cc: tglx@linutronix.de, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <1175897876.28263.490.camel@localhost.localdomain> <200704061557.12662.david-b@pacbell.net>
In-Reply-To: <200704061557.12662.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704080219.39278.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 18:57, David Brownell wrote:
> On Friday 06 April 2007 3:17 pm, Thomas Gleixner wrote:
> > David,
> > 
> > http://tglx.de/private/tglx/usbnet.png
> > 
> > /me recommends emacs-develock.el for colorful white space wreckage
> > display !
> 
> Then I'd have to switch to EMACS ... no thanks!  ;)

Here is what I have in my .vimrc:

highlight RedundantWhitespace ctermbg=red guibg=red
match RedundantWhitespace /\s\+$\| \+\ze\t/

-- 
Dmitry
