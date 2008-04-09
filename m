Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYDINiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYDINiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYDINh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:37:58 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:58686 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbYDINh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:37:57 -0400
Date: Wed, 9 Apr 2008 14:37:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Roel Kluin <12o3l@tiscali.nl>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dz: test after postfix decrement fails in
 dz_console_putchar()
In-Reply-To: <47FC93BC.5020201@tiscali.nl>
Message-ID: <alpine.SOC.1.00.0804091426571.6438@piorun>
References: <47FC93BC.5020201@tiscali.nl>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Roel Kluin wrote:

> When loops reaches 0 the postfix decrement still subtracts, so the test 
> fails

 You are right -- thanks for spotting it!

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

  Maciej

