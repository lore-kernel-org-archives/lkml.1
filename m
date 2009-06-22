Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZFVXgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZFVXgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZFVXfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:35:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbZFVXfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:35:51 -0400
Date: Mon, 22 Jun 2009 16:35:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com, yanli@infradead.org,
       linux@treblig.org
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-Id: <20090622163524.7a03f7ea.akpm@linux-foundation.org>
In-Reply-To: <20090619123738.GA21094@srcf.ucam.org>
References: <20090616154200.GA12715@srcf.ucam.org>
	<20090616173618.353901ee@lxorguk.ukuu.org.uk>
	<20090616164351.GA14353@srcf.ucam.org>
	<20090616181549.496ae0f2@lxorguk.ukuu.org.uk>
	<20090616171732.GA14912@srcf.ucam.org>
	<20090617010138.GA13479@thyme.bj.intel.com>
	<20090617025101.GA27595@srcf.ucam.org>
	<20090618000809.GB16835@thyme.bj.intel.com>
	<20090618154250.GA30209@srcf.ucam.org>
	<20090619071634.GA7671@thyme.bj.intel.com>
	<20090619123738.GA21094@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Would now be a good time to trollishly point at
http://bugzilla.kernel.org/show_bug.cgi?id=13540 ?

We broke "an old Pentium 90 machine" some time after 2.6.18.
