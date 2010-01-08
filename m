Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893Ab0AHSw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0AHSw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259Ab0AHSw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:52:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54861 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0AHSw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:52:27 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] irq: remove not need bootmem code
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 08 Jan 2010 10:52:23 -0800
In-Reply-To: <1262951595-1729-1-git-send-email-yinghai@kernel.org> (Yinghai Lu's message of "Fri\, 08 Jan 2010 03\:53\:11 -0800")
Message-ID: <m14omwpgyg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

YH overall this looks like a good patch series, that enables
additional cleanups beyond what it does.  Thank you for putting this
together.

Eric
