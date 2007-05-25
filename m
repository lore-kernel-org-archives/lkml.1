Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXEYMuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXEYMuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXEYMuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:50:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:62819 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbXEYMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:50:07 -0400
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
References: <fa.mF3GWjxaUtH4GJg0vJ8o0F2EuwE@ifi.uio.no>
	<4651464B.4080903@shaw.ca>
From: Holger Eitzenberger <holger@my-eitzenberger.de>
Date: Fri, 25 May 2007 14:49:57 +0200
In-Reply-To: <4651464B.4080903@shaw.ca> (Robert Hancock's message of "Mon,
 21 May 2007 01:12:11 -0600")
Message-ID: <87fy5lhxu2.fsf@kruemel.my-eitzenberger.de>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX19YHUtjPLZHNdqsWpydBDFBAXdotvLZawavTTF
 wTZQsr7duhoK3TZiJ91kHv8wAGYs3TFw+b/Iig06vXfqRuhUYZ
 bj4v5j3hlVwFtsDlbDzlg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> writes:

> Also, it's unrelated to this problem, but you should check the BIOS
> settings for the SATA controller - you really want to get the
> controller into AHCI mode for best performance.

Hi,

just curious, what makes you think that AHCI is better wrt performance?

  /holger

