Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZEVPN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZEVPN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbZEVPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:13:50 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:47572 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbZEVPNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:13:50 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UART regs: add OMAP wakeup-enable register
References: <1242925798-29672-1-git-send-email-khilman@deeprootsystems.com>
	<20090521203725.6d9beaaf@lxorguk.ukuu.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 22 May 2009 08:13:48 -0700
In-Reply-To: <20090521203725.6d9beaaf@lxorguk.ukuu.org.uk> (Alan Cox's message of "Thu\, 21 May 2009 20\:37\:25 +0100")
Message-ID: <873aax891v.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Thu, 21 May 2009 10:09:58 -0700
> Kevin Hilman <khilman@deeprootsystems.com> wrote:
>
>> Add the wakeup enable register to the list of OMAP-specific UART
>> registers.  This is to support forthcoming OMAP PM enhancements which
>> use the wakeup feature of the OMAP's 8250-based UART.
>> 
>> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>> ---
>> The MAINTAINERS file lists the 8250 driver as orphaned, and posts to
>> linux-serial go unanswered.  How should this go upstream?
>
> Via me - I'm sort of defacto serial/8250 caretaker.

OK, good to know.

So are you planning to pull this one in for the  next merge window?

Kevin
