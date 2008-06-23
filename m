Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbYFWIjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbYFWIjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYFWIjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:39:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:46575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYFWIjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:39:44 -0400
From: Andreas Schwab <schwab@suse.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, kernel list <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, jgarzik@pobox.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org>
	<20080623082055.GB1850@elf.ucw.cz>
X-Yow: I want EARS!  I want two ROUND BLACK EARS to make me feel warm 'n secure!!
Date: Mon, 23 Jun 2008 10:39:40 +0200
In-Reply-To: <20080623082055.GB1850@elf.ucw.cz> (Pavel Machek's message of
	"Mon, 23 Jun 2008 10:20:55 +0200")
Message-ID: <je63s0sfxv.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:

> +	   controller, the controller could hang. In other cases it
> +	   could return partial data returning in data
> +	   corruption. This problem has been seen in PPC systems and

s/returning/resulting/ ?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
