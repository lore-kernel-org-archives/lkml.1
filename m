Return-Path: <linux-kernel-owner+w=401wt.eu-S1765591AbYEBMPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765591AbYEBMPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763654AbYEBMPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:15:08 -0400
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1042 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763858AbYEBMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:15:07 -0400
Message-ID: <481B05C9.9060103@xs4all.nl>
Date: Fri, 02 May 2008 14:15:05 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: question about circular locking dependency
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While shutting down 2.6.25 on my VIA EK8000, just before turning off the
encrypted swap, I noticed messages about a circular locking dependency
rolling over the screen. The messages were not in /var/log/messages
after reboot.
The machine did shut down and restart without further problems.

I assume a serial console is the only way to capture the error messages
of this circular locking dependency.
Or are there alternatice methods?

Is this specific circular locking dependency a known issue?

Kind regards,
Udo
