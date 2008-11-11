Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYKKMNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYKKMNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbYKKMNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:13:17 -0500
Received: from rfc2324.org ([89.149.194.216]:55005 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbYKKMNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:13:16 -0500
X-Greylist: delayed 2068 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2008 07:13:16 EST
Date: Tue, 11 Nov 2008 12:38:43 +0100
From: Maximilian Wilhelm <max@rfc2324.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Message-ID: <20081111113838.GA3474@outback.rfc2324.org>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 2.6.23.9-grsec on i686
X-Warning: This message may contain ironic / sarcastic elements.
X-GC-3.12: GCM/CS/IT d+(--) s+: a-- C++>$ UL++++$ US>++++ P++ L+++>++++ E--- W+ N o+ K- w O? M? V? PS+ PE Y+ PGP++ t 5? X- R tv b+(++) DI+(++) !D G++ e>+++  h!>--(---) r++ y+
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: max@rfc2324.org
Subject: Status of Xen in vanilla?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on rfc2324.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm wondering about the status of Xen support in the vanilla kernel.
I know that DomU support is inside the kernel an evolving, but I did
not find an up-to-date hint about the status of Dom0 support.

A while ago I read that it should be included in 2.6.28, but I do not
find any current pointer about the status of this.

Thanks for hacking on it!

(No need for CC'ing me, I'm subscribed.)

Ciao
Max
-- 
	Follow the white penguin.
