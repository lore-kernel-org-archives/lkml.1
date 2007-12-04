Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbXLDWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbXLDWXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXLDWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:23:08 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:62734 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXLDWXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ajT04+OADxu+dG09Z7EVfkwnaKY9duszCr5dcKWgYrxcmbcE8Hls3Sr7F2V/J4WnaVF10s0VsvLtwzV7VvIdlVWRtTNvXqka/kReUpOdSgU7rBDBBGvXtJFJk48nFOI/XT1CC4XDc+bNoUwHc03ZSDaz7PgzqMF8HzUbZZImsMg=
Date: Tue, 4 Dec 2007 23:20:45 +0100
From: Diego Calleja <diegocg@gmail.com>
To: =?ISO-8859-1?B?IkouQS4gTWFnYWxs824i?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-Id: <20071204232045.212ba1bf.diegocg@gmail.com>
In-Reply-To: <20071204224745.51e6c2b1@werewolf>
References: <474EAD18.6040408@stellatravel.co.uk>
	<20071130143445.GA2310@csclub.uwaterloo.ca>
	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	<4751BE0D.3050609@argo.co.il>
	<p733aukyl8n.fsf@bingen.suse.de>
	<47539030.10600@argo.co.il>
	<20071203095022.GA28560@one.firstfloor.org>
	<4753ECA5.2010604@argo.co.il>
	<20071203211353.GA4009@1wt.eu>
	<20071203223902.1194aa69@werewolf>
	<20071203215727.543fc757@the-village.bc.nu>
	<20071204224745.51e6c2b1@werewolf>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 4 Dec 2007 22:47:45 +0100, "J.A. Magallón" <jamagallon@ono.com> escribió:

> That is what I like of C++, with good placement of high level features
> like const's and & (references) one can gain fine control over what
> gets copied or not.

But...if there's some way Linux can get "language improvements", is with
new C standards/gccextensions/etc. It'd be nice if people tried to add
(useful) C extensions to gcc, instead of proposing some random language :)
