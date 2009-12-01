Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZLASmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZLASmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZLASmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:42:07 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:53730 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZLASmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:42:06 -0500
Date: Tue, 1 Dec 2009 12:42:10 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Jonathan Miles <jon@cybus.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: OOM kernel behaviour
In-Reply-To: <4B155B4A.9050405@cybus.co.uk>
Message-ID: <alpine.DEB.2.00.0912011241400.10926@router.home>
References: <4B1402FC.80307@cybus.co.uk> <alpine.DEB.2.00.0911301253410.18682@router.home> <4B14E8A2.4020500@cybus.co.uk> <alpine.DEB.2.00.0912010949400.8841@router.home> <4B155B4A.9050405@cybus.co.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Jonathan Miles wrote:

> Okay, so my kernel shouldn't be behaving like this?

No it should properly do reclaim.

