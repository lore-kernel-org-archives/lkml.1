Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXJ2NrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXJ2NrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXJ2NrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:47:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12144 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXJ2NrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:47:11 -0400
Date: Mon, 29 Oct 2007 09:45:47 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mike Waychison <mikew@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Waychison <mikew@google.com>
Subject: Re: [patch 5/6][RFC] Introduce FIBMAP64
Message-ID: <20071029094547.3627e442@think.oraclecorp.com>
In-Reply-To: <20071026233848.939953744@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
	<20071026233848.939953744@crlf.corp.google.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 16:37:37 -0700
Mike Waychison <mikew@google.com> wrote:

> Introduce FIBMAP64.  This is the same as FIBMAP, but takes a u64.

If we're adding new ioctls, I'd rather see the FIEMAP stuff go
in, a quick search found discussions but has it died off?

-chris
