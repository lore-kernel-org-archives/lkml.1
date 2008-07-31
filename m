Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYGaKnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYGaKnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYGaKnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:43:23 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:41894 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbYGaKnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:43:22 -0400
Date: Thu, 31 Jul 2008 12:43:19 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc1 process time accounting
Message-ID: <20080731104319.GB5806@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 31 Jul 2008 12:43:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think there is a regression since 2.6.26 in time accounting of processes.

kthreadd and console-kit-daemons claim they spent 5124095 hours using CPU.

-- 
Luká¹ Hejtmánek
