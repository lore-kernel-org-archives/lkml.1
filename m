Return-Path: <linux-kernel-owner+w=401wt.eu-S1422726AbXDRJeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbXDRJeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422723AbXDRJeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:34:05 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38877 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726AbXDRJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:34:04 -0400
Message-ID: <4625E5E9.5060100@s5r6.in-berlin.de>
Date: Wed, 18 Apr 2007 11:33:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
References: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Anthony Kazos Jr. wrote:
> Convert the subdirectory "crypto" to UTF-8. The files changed are 
> <crypto/fcrypt.c> and <crypto/api.c>.

Aren't we using ASCII for C sources?
-- 
Stefan Richter
-=====-=-=== -=-- =--=-
http://arcgraph.de/sr/
