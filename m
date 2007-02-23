Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXBWAVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXBWAVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXBWAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:21:10 -0500
Received: from colin.muc.de ([193.149.48.1]:1656 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXBWAVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:21:09 -0500
Date: 23 Feb 2007 01:21:08 +0100
Date: Fri, 23 Feb 2007 01:21:08 +0100
From: Andi Kleen <ak@muc.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
Message-ID: <20070223002108.GA4222@muc.de>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222112207.GA10190@muc.de> <45DDC810.3000401@zytor.com> <45DDD538.1040309@goop.org> <20070222183628.GA65601@muc.de> <45DDE56C.7060704@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DDE56C.7060704@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To some degree linux-arch would be a good list for it, but it's closed, 
> even to monitor.

linux-arch is only for architecture code, but yes it serves a similar
purpose. But it's very specialized. What is discussed there is unlikely
to be of much interest to most people.

I was thinking of a relatively low volume list where quick notes for
any general interfaces changes that likely needs adaptions in a wide range of
code could be sent. Then even people who cannot follow l-k or git due
to volume could subscribe to that and adapt their code as needed.

-Andi
