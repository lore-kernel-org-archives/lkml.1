Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXK2RCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXK2RCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbXK2RCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:02:33 -0500
Received: from [198.99.130.12] ([198.99.130.12]:48220 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760708AbXK2RCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:02:33 -0500
Date: Thu, 29 Nov 2007 12:02:05 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: scheduling anomaly on uml (was: -rt doesn't compile for UML)
Message-ID: <20071129170205.GA7415@c2.user-mode-linux.org>
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org> <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu> <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxgUe-00011b-Sl@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:19:40AM +0100, Miklos Szeredi wrote:
>     date-7119  0.... 15636591us!: schedule <bash-502> (0 0)
>     bash-502   0.... 15643908us!: schedule <date-7119> (0 0)
>     bash-502   0.... 15646250us!: schedule <date-7120> (0 0)

How exactly did you end up getting this data?

And is there something I can read to tell what it means?

			Jeff

-- 
Work email - jdike at linux dot intel dot com
