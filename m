Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYKRPY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYKRPY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYKRPYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:24:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37584 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751076AbYKRPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:24:49 -0500
Date: Tue, 18 Nov 2008 15:24:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Switch WM8350 revision detection to a feature
	based model
Message-ID: <20081118152447.GA19958@rakim.wolfsonmicro.main>
References: <1227021737-19913-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227021737-19913-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Thank god!! ... It's HENNY YOUNGMAN!!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 03:22:17PM +0000, Mark Brown wrote:
> Rather than check for chip revisions in the WM8350 drivers have the core
> code set flags for relevant differences.

Gah, ignore this - it's broken.  Sorry.
