Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0AXAX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0AXAX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 19:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776Ab0AXAXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 19:23:55 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:55672 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0AXAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 19:23:55 -0500
Date: Sun, 24 Jan 2010 01:23:52 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: cleanup switches with cases that can be merged
Message-ID: <20100124002352.GB3251@linux-mips.org>
References: <4B56475F.8070608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B56475F.8070608@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:59:27AM +0100, Roel Kluin wrote:

> I did a search for switch statements with cases that can be merged, but maybe
> some were not intended?
> ---------------->8------------------------------------------8<-----------------
> In these cases the same code was executed.

Queued for 2.6.34.

  Ralf
