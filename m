Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYFXEE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYFXEE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYFXEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:04:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40153 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339AbYFXEDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:03:55 -0400
Date: Tue, 24 Jun 2008 13:01:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] maple: tidy  maple_driver code by removing redundant connect/disconnect
Message-ID: <20080624040128.GB22526@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1213559289.22707.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213559289.22707.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 08:48:09PM +0100, Adrian McMenamin wrote:
> The connect and disconnect functions are unnecessary - everything they do can be
> accomplished in the initial probe - so remove them.
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Applied, thanks.
