Return-Path: <linux-kernel-owner+w=401wt.eu-S1764214AbYCEV4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764214AbYCEV4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764065AbYCEV41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:56:27 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59558 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764062AbYCEV4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:56:25 -0500
Date: Wed, 5 Mar 2008 13:56:13 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: netfilter-devel@vger.kernel.org, joe@perches.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
In-Reply-To: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0803051355140.31527@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <clameter@sgi.com>

I guess this should go through the netdev tree?


