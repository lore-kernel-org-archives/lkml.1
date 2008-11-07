Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYKHEa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYKHEa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 23:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYKHEat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 23:30:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:51307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYKHEas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 23:30:48 -0500
Date: Fri, 7 Nov 2008 15:05:14 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt LaPlante <kernel1@cyberdogtech.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] Change default for STRICT_DEVMEM
Message-ID: <20081107150514.6831c902@infradead.org>
In-Reply-To: <20081107220038.50345845@lxorguk.ukuu.org.uk>
References: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
	<20081107220038.50345845@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 22:00:38 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri,  7 Nov 2008 14:18:36 -0600
> Matt LaPlante <kernel1@cyberdogtech.com> wrote:
> 
> > The recommendation for STRICT_DEVMEM is to select Y,
> > however the option currently defaults to N.  Have the option
> > default to Y since it is recommended.
> 
> The recommendation is extremely dubious as it breaks a lot of back
> compatibility.
> 

the default recommendatiom is a typo. It used to be an "other way
around" config option, and it got flipped into a "positive" option
rather than a tripple negative, but the help text didn't get fixed
properly.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
