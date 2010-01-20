Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228Ab0ATTwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0ATTwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156Ab0ATTwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:52:14 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:47654 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0ATTwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:52:12 -0500
Date: Wed, 20 Jan 2010 13:51:16 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/37] x86: move range related operation to one file
In-Reply-To: <4B575B68.4030809@kernel.org>
Message-ID: <alpine.DEB.2.00.1001201350310.15175@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-2-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191048480.22304@router.home> <4B575B68.4030809@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Yinghai Lu wrote:

> > Subtract range can now do what update_range did? How so?
>
> update_range was introduced at first. and actually it did sth like subtract range.
>
> and subtract range is more accurate.

Subtract range suggest that you may be removing the range.

subtract_from_range?

