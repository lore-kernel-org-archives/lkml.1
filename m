Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbXF2WmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbXF2WmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXF2WmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:42:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbXF2WmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:42:00 -0400
From: Andreas Schwab <schwab@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to determine if the noexec stack is defined by an application
References: <46856F24.5060407@andrei.myip.org>
	<1183153758.2894.1.camel@laptopd505.fenrus.org>
	<jefy4aflvs.fsf@sykes.suse.de>
	<1183156068.2894.4.camel@laptopd505.fenrus.org>
X-Yow: Where's my SOCIAL WORKER?
Date: Sat, 30 Jun 2007 00:41:58 +0200
In-Reply-To: <1183156068.2894.4.camel@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Fri\, 29 Jun 2007 15\:27\:47 -0700")
Message-ID: <jebqeyfknd.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> (all others default to executable stack)

Except ia64.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
