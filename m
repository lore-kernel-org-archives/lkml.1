Return-Path: <linux-kernel-owner+w=401wt.eu-S376256AbXECRX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376256AbXECRX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376257AbXECRX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:23:58 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:56048 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376256AbXECRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:23:56 -0400
Date: Thu, 3 May 2007 18:23:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/10] mips: tlbex: use __attribute_unused__
Message-ID: <20070503172348.GB10249@linux-mips.org>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com> <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:28:45PM -0700, David Rientjes wrote:

> Replace function instances of __attribute__((unused)) with
> __attribute_unused__.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
