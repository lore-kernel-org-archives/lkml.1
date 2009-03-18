Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZCRRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZCRRD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZCRRDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:03:18 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:36463 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZCRRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:03:17 -0400
Date: Wed, 18 Mar 2009 12:58:57 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nitin Gupta <ngupta@vflare.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
In-Reply-To: <49C11088.7000205@vflare.org>
Message-ID: <alpine.DEB.1.10.0903181258110.15570@qirst.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>  <alpine.DEB.1.10.0903171237180.21582@qirst.com> <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com> <alpine.DEB.1.10.0903171355410.26058@qirst.com>
 <49C11088.7000205@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Nitin Gupta wrote:

> > Slab memory is not backed by vmalloc space.
> Oh, it uses "low memory". Still not good for compcache :)

Only if you use 32 bit.
