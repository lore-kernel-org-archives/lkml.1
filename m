Return-Path: <linux-kernel-owner+w=401wt.eu-S1760499AbYBRNS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499AbYBRNS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYBRNST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:18:19 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:19706 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYBRNSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:18:18 -0500
Date: Mon, 18 Feb 2008 14:18:13 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       tglx@linutronix.de, buytenh@wantstofly.org, mingo@elte.hu,
       riku.voipio@movial.fi, stable@kernel.org, schwidefsky@de.ibm.com
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
Message-ID: <20080218131813.GA14536@osiris.boeblingen.de.ibm.com>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org> <20080216124248.GA4900@osiris.boeblingen.de.ibm.com> <20080218050030.658f524d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218050030.658f524d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 05:00:30AM -0800, Andrew Morton wrote:
> On Sat, 16 Feb 2008 13:42:48 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > To: linux-kernel@vger.kernel.org
> > Cc: mm-commits@vger.kernel.org, tglx@linutronix.de, buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi, stable@kernel.org, schwidefsky@de.ibm.com
> 
> Hrm, people have suddenly started removing me from the cc's on mm-commits
> replies.  Please don't, else I'll end up sending dud patches into mainline.

Ah.. not a bug but a feature: your mails sent via mm-commit have you as
sender but also

Reply-to: linux-kernel@vger.kernel.org

in the mail header. That's why this happens.
