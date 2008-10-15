Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYJOOPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYJOOPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYJOOPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:15:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54900 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754082AbYJOOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:15:17 -0400
Date: Wed, 15 Oct 2008 15:15:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH] mfd: Don't use NO_IRQ in WM8350
Message-ID: <20081015141514.GA25479@rakim.wolfsonmicro.main>
References: <1224066054-24401-1-git-send-email-broonie@opensource.wolfsonmicro.com> <9fb8beea82becda1567755f13aab4c11@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fb8beea82becda1567755f13aab4c11@localhost>
X-Cookie: I disagree with unanimity.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 07:55:17AM -0400, Samuel Ortiz wrote:

> I'll send a pull request to Linus soon.

Thanks, it's fairly urgent since it breaks allmodconfig and allyesconfig
on at least x86_64.
