Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbYKGWEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbYKGWEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYKGWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:04:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40799 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbYKGWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:04:40 -0500
Date: Fri, 7 Nov 2008 22:00:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Matt LaPlante <kernel1@cyberdogtech.com>
Subject: Re: [PATCH] Change default for STRICT_DEVMEM
Message-ID: <20081107220038.50345845@lxorguk.ukuu.org.uk>
In-Reply-To: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
References: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Nov 2008 14:18:36 -0600
Matt LaPlante <kernel1@cyberdogtech.com> wrote:

> The recommendation for STRICT_DEVMEM is to select Y,
> however the option currently defaults to N.  Have the option
> default to Y since it is recommended.

The recommendation is extremely dubious as it breaks a lot of back
compatibility.

