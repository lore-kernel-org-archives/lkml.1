Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZHGVRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZHGVRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZHGVRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:17:07 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:60503 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZHGVRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:17:06 -0400
Date: Fri, 7 Aug 2009 23:16:58 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Johannes Stezenbach <js@sig21.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       reinette chatre <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090807211658.GM3382@ics.muni.cz>
References: <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
 <20090804084903.GV3382@ics.muni.cz>
 <1249426183.30019.4581.camel@rc-desk>
 <20090804225626.GZ3382@ics.muni.cz>
 <1249429081.30019.4588.camel@rc-desk>
 <20090806132244.GC15867@khazad-dum.debian.net>
 <20090806224110.GJ3382@ics.muni.cz>
 <20090806230704.GA14381@khazad-dum.debian.net>
 <20090807203226.GA13867@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090807203226.GA13867@sig21.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 07 Aug 2009 23:16:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:32:26PM +0200, Johannes Stezenbach wrote:
> In Documentation/laptops/thinkpad-acpi.txt there is this comment
> for FN+F5:
> 
>    Should be used to turn on/off all radios (Bluetooth+W-WAN+WLAN), really.
> 
> I disagree.  Why would anyone turn off all radios at once?
> What I want is to disable the radios I don't need to save power,
> so IMHO there should be different keys for Bluetooth and WLAN
> (and W-WAN where present).

in my case, it disables only WLAN. BT is untouched.

-- 
Luká¹ Hejtmánek
