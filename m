Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYDWMlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYDWMlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYDWMlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:41:09 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:54227 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYDWMlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:41:08 -0400
Date: Wed, 23 Apr 2008 14:41:06 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: iwl4965 regression since 2.6.24
Message-ID: <20080423124105.GA4783@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 206.196.180.225
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 23 Apr 2008 14:41:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as of 2.6.25 kernel, the intel driver iwl4965 has serious troubles to
associate with AP. I must many times set essid till the association is done.

Moreover, it seems that it is unable to associate with different AP (using the
same SSID). I must remove the module completly to be able to associate to the
different AP. I think it is big regression.

-- 
Luká¹ Hejtmánek
