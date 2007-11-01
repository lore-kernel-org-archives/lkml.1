Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbXKAIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbXKAIjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXKAIjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:39:08 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:52456 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbXKAIjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:39:08 -0400
Message-ID: <472990A9.4000309@s5r6.in-berlin.de>
Date: Thu, 01 Nov 2007 09:39:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: remove CONFIG_EXPERIMENTAL
References: <20071101050855.GY7227@stusta.de>
In-Reply-To: <20071101050855.GY7227@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> I'm about to send a patch that removes the EXPERIMENTAL option and all 
> dependencies on EXPERIMENTAL because they are pointless.

FWIW, I agree.

[...]
>   As an example, is our NFSv4 support really still in an
>   "alpha-test phase" [1], or is it already ready for being used?
[...]
> [1] quoted from the CONFIG_EXPERIMENTAL help text

I don't know about NFSv4 in particular, but I think we have the whole
palette, from "alpha" software which is basically ready for production,
to buggy incomplete software which is heavily in production and trains
users to lower their expectations.
-- 
Stefan Richter
-=====-=-=== =-== ----=
http://arcgraph.de/sr/
