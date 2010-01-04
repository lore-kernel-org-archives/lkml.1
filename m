Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541Ab0ADVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0ADVYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380Ab0ADVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:24:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:37660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0ADVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:24:30 -0500
Message-ID: <4B425C43.6040009@kernel.org>
Date: Mon, 04 Jan 2010 13:23:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH -v2 0/25] x86: use early_res instead of bootmem before
 slab
References: <1261525263-13763-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001041147240.7191@router.home> <4B4259FB.1000804@kernel.org> <alpine.DEB.2.00.1001041519180.16200@router.home>
In-Reply-To: <alpine.DEB.2.00.1001041519180.16200@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 01:19 PM, Christoph Lameter wrote:
> On Mon, 4 Jan 2010, Yinghai Lu wrote:
> 
>> http://lkml.indiana.edu/hypermail/linux/kernel/0910.3/01432.html
> 
> Ahh. Maybe use that material in your introduction somewhere?

sure. next version.

YH
