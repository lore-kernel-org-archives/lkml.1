Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYJDUBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYJDUBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYJDUBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:01:25 -0400
Received: from server.drzeus.cx ([85.8.24.28]:59969 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752089AbYJDUBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:01:25 -0400
Date: Sat, 4 Oct 2008 22:01:19 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MMC: CSD and CID timeout values
Message-ID: <20081004220119.6cdf37df@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50810020457m13bd38d3i72609171ff0dcc4f@mail.gmail.com>
References: <5ff4a1e50810020457m13bd38d3i72609171ff0dcc4f@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 12:57:14 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> From 9a083f0e9a81f5bc31ea49f37112f1945830fc7c Mon Sep 17 00:00:00 2001
> From: Matthew Fleming <matthew.fleming@imgtec.com>
> Date: Thu, 2 Oct 2008 12:24:05 +0100
> Subject: [PATCH 2/2] MMC: CSD and CID timeout values
> 
> The MMC spec states that the timeout for accessing the CSD and CID
> registers is 64 clock cycles.
> 
> Signed-off-by: Matthew Fleming <matthew.fleming@imgtec.com>

Applied both patches. Thanks. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
