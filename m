Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbXGaK5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbXGaK5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXGaK5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:57:34 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:58263 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbXGaK5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:57:33 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: acpi=off vs. blacklist
Date: Tue, 31 Jul 2007 12:57:16 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200707311235.53302.philipp.marek@bmlv.gv.at> <46AF10BF.2090303@googlemail.com>
In-Reply-To: <46AF10BF.2090303@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311257.16983.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 31. Juli 2007, Gabriel C wrote:
> [ added linux-acpi to CC ]

Sorry, forgot to mention:
I'd like to use 2.6.20.1, but I already tested with 2.6.22.1.

IIUC if there's a problem with the ACPI tables, the blacklist won't help, 
because to know whether the ACPI blacklist applies ACPI tables must be 
parsed :-/ ?


Regards,

Phil
