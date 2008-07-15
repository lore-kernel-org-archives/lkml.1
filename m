Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbYGOMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbYGOMl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYGOMlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:41:51 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52376 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756154AbYGOMlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:41:50 -0400
Date: Tue, 15 Jul 2008 14:41:47 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, dhowells@redhat.com, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix SDIO break control to now return success or an
 error
Message-ID: <20080715144147.74bf2bb3@mjolnir.drzeus.cx>
In-Reply-To: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
References: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 12:28:48 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix SDIO break control to now return success or an error.
> 
> This is a consequence of patch 9ea761bfef52c116fed4715d4043392c2503fe6a.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---

Applied, thanks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
