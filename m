Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbYGRX2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbYGRX2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbYGRX2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:28:12 -0400
Received: from server.drzeus.cx ([85.8.24.28]:55748 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757747AbYGRX2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:28:11 -0400
Date: Sat, 19 Jul 2008 01:28:09 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: s3cmci.c fixes for section mismatch warnings
Message-ID: <20080719012809.6b7f031e@mjolnir.drzeus.cx>
In-Reply-To: <20080717105401.187834638@fluff.org.uk>
References: <20080717105401.187834638@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 11:54:01 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Fix the naming of various functions in the s3cmc
> driver to stop triggering section mismatch warnings.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

Applied.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
