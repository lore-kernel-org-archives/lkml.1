Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbXJ3WQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbXJ3WQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXJ3WPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:15:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061AbXJ3WPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:15:18 -0400
Date: Tue, 30 Oct 2007 15:14:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH 9/16] CRIS architecture: Correct compile errors
Message-Id: <20071030151414.d5e960c6.akpm@linux-foundation.org>
In-Reply-To: <20071030093231.GL11960@axis.com>
References: <20071030093231.GL11960@axis.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 10:32:31 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> New (updated) version of ethernet driver for cris v10.

This driver (and this patch) contain a large number of trivial
coding-style glitches.  Please always pass the diffs through
scripts/checkpatch.pl and review the output, thanks.
