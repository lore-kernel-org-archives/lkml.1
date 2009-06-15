Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbZFOQac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbZFOQac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZFOQaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:30:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48079 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753954AbZFOQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:30:21 -0400
Date: Mon, 15 Jun 2009 17:30:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Rapoport <mike@compulab.co.il>,
       Balaji Rao <balajirrao@openmoko.org>, Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH] mfd: early init for MFD running regulators
Message-ID: <20090615163021.GA16537@rakim.wolfsonmicro.main>
References: <20090615162813.GE4094@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615162813.GE4094@sortiz.org>
X-Cookie: glibido:
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 06:28:14PM +0200, Samuel Ortiz wrote:

> From: Samuel Ortiz <sameo@linux.intel.com>

> For MFDs running regulator cores, we really want them to be brought up early
> during boot.

> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
