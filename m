Return-Path: <linux-kernel-owner+w=401wt.eu-S1763717AbYCEV6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763717AbYCEV6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYCEV6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:58:21 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52478 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbYCEV6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:58:19 -0500
Message-ID: <47CF1730.6000906@cs.helsinki.fi>
Date: Wed, 05 Mar 2008 23:57:04 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: netfilter-devel@vger.kernel.org, joe@perches.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0803051355140.31527@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803051355140.31527@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph Lameter wrote:
> Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> I guess this should go through the netdev tree?

Yup.

		Pekka
