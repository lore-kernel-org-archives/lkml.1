Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYKTSOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYKTSOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYKTSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:14:32 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:38197 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYKTSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:14:32 -0500
Date: Thu, 20 Nov 2008 12:14:02 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Possible memory leak via slub kmem_cache_create
In-Reply-To: <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
Message-ID: <Pine.LNX.4.64.0811201212040.23154@quilx.com>
References: <1227111954.27162.28.camel@pc1117.cambridge.arm.com> 
 <Pine.LNX.4.64.0811191319360.23084@quilx.com> <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I have reviewed a patch like this before. Wonder where it went.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


