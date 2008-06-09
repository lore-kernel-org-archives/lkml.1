Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYFIABy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYFIABy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYFIABp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:01:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbYFIABp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:01:45 -0400
Date: Sun, 8 Jun 2008 17:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH] ac97: add support for wm9711 master left inv switch
Message-Id: <20080608170127.b9610d2e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
References: <Pine.LNX.4.64.0806061659550.3338@axis700.grange>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 17:02:57 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@pengutronix.de> wrote:

> From: Juergen Beisert <j.beisert@pengutronix.de>
> 
> This patch adds support for Master Left Inv Switch on wm9711.
> At least required to drive the mono speaker on the PXA270 platfrom
> 
> Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>

Please include your own signed-off-by when forwarding other people's patches.

