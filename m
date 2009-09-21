Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZIUPIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZIUPIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZIUPIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:08:10 -0400
Received: from fifo99.com ([67.223.236.141]:56670 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbZIUPIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:08:09 -0400
Subject: Re: [PATCH] Driver-Core: extend devnode callbacks to provide
 permissions
From: Daniel Walker <dwalker@fifo99.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1253307672.1864.0.camel@yio.site>
References: <1253307672.1864.0.camel@yio.site>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 08:08:16 -0700
Message-Id: <1253545696.9654.224.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 23:01 +0200, Kay Sievers wrote:
> 
> This also fixes a wrong assignment in pktcdvd and a checkpatch.pl complain.

Thanks for doing the checkpatch clean up..

Daniel

