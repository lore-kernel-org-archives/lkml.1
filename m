Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXGCVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXGCVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762121AbXGCVlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:41:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:35893 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762073AbXGCVlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:41:44 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200707032332.49694.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031456.40890.rjw@sisk.pl>
	 <1183497290.3388.4.camel@localhost.localdomain>
	 <200707032332.49694.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 07:35:55 +1000
Message-Id: <1183498555.3388.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 23:32 +0200, Rafael J. Wysocki wrote:
> 
> Still, do you really think that we're ready to drop it _right_ _now_
> (I'm
> referring to suspend only) and if so than on what basis (except that
> you
> don't like it, which falls short of being a techical argument)?

Works fine for me without it ;-)

Ben.


