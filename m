Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYIZKFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYIZKFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYIZKFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:05:09 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40880 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbYIZKFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:05:08 -0400
Date: Fri, 26 Sep 2008 12:05:07 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_SECURITY_ROOTPLUG [was: Re: 2.6.27-rc7 no init found on
	the root partition?]
Message-ID: <20080926100507.GR31582@ics.muni.cz>
References: <20080925165400.GQ31582@ics.muni.cz> <20080926024927.GA13816@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080926024927.GA13816@hallyn.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 26 Sep 2008 12:04:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 09:49:27PM -0500, Serge E. Hallyn wrote:
> Hmm, is there a difference in the device drivers such that root_plug simply
> isn't able to find the usb 'key' in 2.6.27-rc7?
> 
> When you boot with CONFIG_SECURITY_ROOTPLUG=n, can you read the usb key?

I do not have USB key at all. So maybe there is a security bug in 2.6.26.3?

-- 
Luká¹ Hejtmánek
