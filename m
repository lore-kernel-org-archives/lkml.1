Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYFNNfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYFNNfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 09:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYFNNfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 09:35:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57842 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYFNNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 09:35:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4853C8AD.9020407@s5r6.in-berlin.de>
Date: Sat, 14 Jun 2008 15:33:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] 8139too: clean up spaces and TABs
References: <4853BB62.1060109@freemail.hu>
In-Reply-To: <4853BB62.1060109@freemail.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> -/* The following settings are log_2(bytes)-4:  0 == 16 bytes .. 6==1024, 7==end of packet. */
> +/* The following settings are log_2(bytes)-4:
> +   0 == 16 bytes .. 6==1024, 7==end of packet. */

We don't write comments like this.
-- 
Stefan Richter
-=====-==--- -==- -===-
http://arcgraph.de/sr/
