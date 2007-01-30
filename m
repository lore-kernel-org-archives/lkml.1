Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXA3Clf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXA3Clf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 21:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXA3Clf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 21:41:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbXA3Cle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 21:41:34 -0500
Date: Mon, 29 Jan 2007 18:41:13 -0800
From: Andrew Morton <akpm@osdl.org>
To: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] TSL2550 support (I2C device driver)
Message-Id: <20070129184113.55ab6b65.akpm@osdl.org>
In-Reply-To: <20070129183950.00ef3a04.akpm@osdl.org>
References: <20070129235619.GA8882@enneenne.com>
	<20070129183950.00ef3a04.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 18:39:50 -0800
Andrew Morton <akpm@osdl.org> wrote:

> > attached a patch to add support for Taos TSL2550 ambient light sensors
> > (http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).
> > 
> 
> Some minor things:

Oh, and please send a signoff for this work as per section 11 of
Documentation/SubmittingPatches, thanks.
