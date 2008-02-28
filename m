Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbYB1XWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbYB1XWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYB1XWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:22:45 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56566 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbYB1XWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:22:45 -0500
Date: Fri, 29 Feb 2008 00:04:25 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Switact - Thomas Roes <info@switact.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Realtek link issue with SLED10SP1
Message-ID: <20080228230425.GB13100@electric-eye.fr.zoreil.com>
References: <47BEB94B.8070306@switact.nl> <20080222224924.GA19397@electric-eye.fr.zoreil.com> <47C2D3BA.9010904@switact.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C2D3BA.9010904@switact.nl>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switact - Thomas Roes <info@switact.nl> :
[...]
> I need a working solution for a kernel 2.6.16.46 (SLED10SP1)
> All drivers I tested work on kernel 2.6.18-6 (and up)

Try http://userweb.kernel.org/~romieu/r8169/2.6.16/stable-46/to-2.6.24/

It contains a patch for the r8169 driver which should apply to your
2.6.16.46 based kernel and turn its r8169 driver into something closer
to 2.6.24. The kit contains a stack of incremental patches too if you
are curious.

I have fixed some rejects, checked that everything compiles at each
step but the patch is otherwise untested. Use at your own risk.

-- 
Ueimor
