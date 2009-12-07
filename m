Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbZLGSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbZLGSlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbZLGSlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:41:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbZLGSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:41:18 -0500
Message-ID: <4B1D4C38.2060801@zytor.com>
Date: Mon, 07 Dec 2009 10:40:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Emese Revfy <re.emese@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/31] Constify struct mtrr_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com> <4B198F61.7010304@gmail.com>
In-Reply-To: <4B198F61.7010304@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 02:38 PM, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct mtrr_ops.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

