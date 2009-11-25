Return-Path: <linux-kernel-owner+w=401wt.eu-S934963AbZKYUPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbZKYUPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbZKYUPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:15:33 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:34264 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212AbZKYUPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:15:33 -0500
Date: Wed, 25 Nov 2009 14:15:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
In-Reply-To: <4B0D77CC.3020807@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0911251414480.4779@router.home>
References: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi> <1259173636.29779.41.camel@Joe-Laptop.home> <4B0D77CC.3020807@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Pekka Enberg wrote:

> Because that has no effect on the generated code.

Does this affect the cycle count in slab_alloc?

