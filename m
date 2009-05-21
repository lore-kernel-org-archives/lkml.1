Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZEUTg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZEUTg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZEUTgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:36:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42227 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751872AbZEUTgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:36:20 -0400
Date: Thu, 21 May 2009 20:37:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] UART regs: add OMAP wakeup-enable register
Message-ID: <20090521203725.6d9beaaf@lxorguk.ukuu.org.uk>
In-Reply-To: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
References: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 10:09:58 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> Add the wakeup enable register to the list of OMAP-specific UART
> registers.  This is to support forthcoming OMAP PM enhancements which
> use the wakeup feature of the OMAP's 8250-based UART.
> 
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
> The MAINTAINERS file lists the 8250 driver as orphaned, and posts to
> linux-serial go unanswered.  How should this go upstream?

Via me - I'm sort of defacto serial/8250 caretaker.
