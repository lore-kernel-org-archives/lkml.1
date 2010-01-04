Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607Ab0ADRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0ADRxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221Ab0ADRw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:52:59 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:57218 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0ADRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:52:58 -0500
Date: Mon, 4 Jan 2010 11:51:33 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "\"Yinghai Lu" <yingai@kernel.org>
Subject: Re: [PATCH -v2 0/25] x86: use early_res instead of bootmem before
 slab
In-Reply-To: <1261525486-13838-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001041150490.7191@router.home>
References: <1261525486-13838-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So you want to allocate lots of memory from higher memory adresses?

