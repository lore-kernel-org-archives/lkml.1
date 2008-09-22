Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYIVPg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYIVPg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIVPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:36:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbYIVPgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:36:50 -0400
From: Andreas Schwab <schwab@suse.de>
To: Halesh S <halesh.sadashiv@ap.sony.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regarding select() on PPC
References: <loom.20080919T140301-79@post.gmane.org>
	<loom.20080922T143915-56@post.gmane.org>
X-Yow: If Robert Di Niro assassinates Walter Slezak, will
 Jodie Foster marry Bonzo??
Date: Mon, 22 Sep 2008 17:36:47 +0200
In-Reply-To: <loom.20080922T143915-56@post.gmane.org> (Halesh S.'s message of
	"Mon, 22 Sep 2008 14:47:03 +0000 (UTC)")
Message-ID: <jeskrs42gg.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Halesh S <halesh.sadashiv@ap.sony.com> writes:

> What is the purpose of Argument check only for PPC32, is ther any specific 
> reason?

Probably long obsolete, it predates linux 2.2.0.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
