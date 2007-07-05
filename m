Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbXGENPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbXGENPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbXGENPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:15:13 -0400
Received: from mx01.hansenet.de ([213.191.73.25]:42692 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756146AbXGENPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:15:12 -0400
Message-ID: <468CEED7.3020109@e-dict.net>
Date: Thu, 05 Jul 2007 15:15:03 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [seems to be SOLVED] Re: md device files missing at boot time
References: <468CB6DC.5020102@e-dict.net>
In-Reply-To: <468CB6DC.5020102@e-dict.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.07.2007 11:16, Ingo Freund wrote (please find the answer below the original text):
> Hi folks,
> 
> I could temporarily only read your answers in archives.
> Thank you for your reaction.
> Hopefully this answer doesn't break the thread.
> If it does:
> sorry for it, there were some mail mail problems
> which stopped our server receiving mails from this list
> and the list auto-unsubscribed me and stopped sending mails :-(
> But it is all fixed now.
> 
> @Kay
> How did you build the initramfs image? /sbin/mkinitrd?
> 
> Did you add md support to the image?
> 
> Both "Yes".
> included modules are (in opensuses /etc/sysconfig/kernel:
> INITRD_MODULES="raid1 md reiserfs sym53c8xx pata_serverworks edd"
> 
> 

@Kay
there was a hidden hint in your text.
"mkinitrd -f md"  made it at least for boot with initramfs

Thanks - Ingo.

