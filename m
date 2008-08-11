Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYHKS5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYHKS5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYHKS4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:56:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbYHKS4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:56:48 -0400
Message-ID: <48A08B55.4030004@linux-foundation.org>
Date: Mon, 11 Aug 2008 13:56:21 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: tbench regression on each kernel release from  2.6.22 -> 2.6.28
References: <48A086B6.2000901@linux-foundation.org> <48A08A11.8040507@intel.com>
In-Reply-To: <48A08A11.8040507@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:

> is this with SLAB or with SLUB? SLUB has been known to impact network performance...

The original testing config was SLAB based so it was used throughout.

