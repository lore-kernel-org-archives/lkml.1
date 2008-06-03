Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYFCKIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYFCKIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFCKIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:08:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:42329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYFCKIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:08:21 -0400
Date: Tue, 3 Jun 2008 12:21:02 +0200
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
Message-ID: <20080603102102.GE22600@suse.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Stefan Assmann <sassmann@suse.de>, linux-kernel@vger.kernel.org
References: <12124107071847-git-send-email-od@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One note on testing:

These patches have been tested several times on machines containing the
PCI bridges that they handle. They solved (most of) the spurious
interrupt issues we had with RT. Some tests have run for several days or
even longer.

Comments?

Regards,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

