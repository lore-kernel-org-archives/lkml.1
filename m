Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYJVUXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYJVUXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYJVUXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:23:23 -0400
Received: from gw.goop.org ([64.81.55.164]:58113 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYJVUXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:23:22 -0400
Message-ID: <48FF8BB9.7050506@goop.org>
Date: Wed, 22 Oct 2008 13:23:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] fix WARN() for PPC
References: <20081020145056.24d84992@infradead.org>
In-Reply-To: <20081020145056.24d84992@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 20 Oct 2008 14:41:03 -0700
> Subject: [PATCH] fix WARN() for PPC
>
> powerpc doesn't use the generic WARN_ON infrastructure.

Hm, why's that now?  The generic infrastructure was taken from powerpc, 
and I thought I'd converted it...

    J
