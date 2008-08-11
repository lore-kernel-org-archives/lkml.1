Return-Path: <linux-kernel-owner+w=401wt.eu-S1751348AbYHKFII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbYHKFII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 01:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYHKFHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 01:07:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYHKFHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 01:07:55 -0400
Message-ID: <489FC913.1050509@zytor.com>
Date: Sun, 10 Aug 2008 22:07:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86, tsc: fix section mismatch warning
References: <20080810220740.GA27349@joi>
In-Reply-To: <20080810220740.GA27349@joi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

I have pulled these four patches into tip:x86/cleanups.

	-hpa

