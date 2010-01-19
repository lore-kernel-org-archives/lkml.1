Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827Ab0ASROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0ASROr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782Ab0ASROp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:14:45 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34974 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0ASROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:14:44 -0500
Date: Tue, 19 Jan 2010 11:13:09 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 14/37] sparsemem: put mem map for one node together.
In-Reply-To: <1263611228-6751-15-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001191110460.22304@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-15-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduces a lot of churn into the early map allocation but looks like its
worth it.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
