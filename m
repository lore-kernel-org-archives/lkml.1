Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYHWKCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYHWKCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 06:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYHWKC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 06:02:27 -0400
Received: from senator.holtmann.net ([87.106.208.187]:51867 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbYHWKC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 06:02:27 -0400
Subject: Re: [PATCH] ath9k: add harmlessly-omitted braces
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Jim Meyering <meyering@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sujith.Manoharan@atheros.com,
       linville@tuxdriver.com
In-Reply-To: <87zln4rzce.fsf@rho.meyering.net>
References: <87zln4rzce.fsf@rho.meyering.net>
Content-Type: text/plain
Date: Sat, 23 Aug 2008 12:02:42 +0200
Message-Id: <1219485762.7591.476.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim

> Alternatively, you could remove the nowadays-useless
> "if-before-kfree" test and leave the sometimes-redundant
> assignment as-is: unconditional.

actually the later one is preferred. Just remove the NULL check.

Regards

Marcel


