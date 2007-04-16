Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXDPI2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXDPI2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXDPI2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:28:38 -0400
Received: from outmail1.freedom2surf.net ([194.106.33.237]:34230 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbXDPI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:28:37 -0400
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
From: ian <spyro@f2s.com>
To: cbou@mail.ru
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ondrej Zajicek <santiago@crfreenet.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
In-Reply-To: <20070416031256.GA30153@zarina>
References: <20070411232503.GC20095@zarina>
	 <20070415220854.GA20373@localhost.localdomain>
	 <20070415225049.GA27680@zarina>
	 <20070416005722.GA6296@khazad-dum.debian.net>
	 <1176690774.29389.175.camel@wirenth>  <20070416031256.GA30153@zarina>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 09:28:14 +0100
Message-Id: <1176712094.29389.191.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 07:12 +0400, Anton Vorontsov wrote:

> Why? With current battery class we can do whatever everyone needs. No
> need for wrappers.

<cut>

> Because of your original design, simple batteries are stay simple, and
> no noticing that there is some "complicated" attributes exists at all.
> That's indeed great characteristic of that *universal* battery class.

Indeed. Im just trying to make sure we dont bloat an otherwise very
simple class. A word of caution only.

