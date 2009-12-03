Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZLCKl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZLCKl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZLCKl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:41:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbZLCKl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:41:27 -0500
Date: Thu, 3 Dec 2009 11:40:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Danny Feng <dfeng@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH -tip] x86: reboot_fixup_32.c add missing pci_dev_put
Message-ID: <20091203104056.GB7628@elte.hu>
References: <1259291762-17735-1-git-send-email-dfeng@redhat.com>
 <20091202100928.GE22654@elte.hu>
 <4B169B1B.8010007@zytor.com>
 <20091202171422.GB28061@elte.hu>
 <4B178DD9.7040502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B178DD9.7040502@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Danny Feng <dfeng@redhat.com> wrote:

> I should point out this in my changelog, sorry for the unclear 
> changelog.

Please re-send it with a better changelog.

Thanks,

	Ingo
