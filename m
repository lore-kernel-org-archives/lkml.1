Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZJWQxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZJWQxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZJWQxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:53:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47400 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368AbZJWQw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:52:59 -0400
Date: Fri, 23 Oct 2009 17:54:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091023175437.49f3a6bb@lxorguk.ukuu.org.uk>
In-Reply-To: <20091023161006.GA1580@ucw.cz>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
	<20091023161006.GA1580@ucw.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It also marks driver as broken when it is not...

Given the changes since anyone last used it I would assume it is.
> 
> What about removing it in the regular way, that's
> Documentation/feature-removal.txt ?

I'd go with that. And remove it ASAP along with about twenty other
similar 'ex drivers'

