Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbYEOP52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbYEOP52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbYEOP5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:57:18 -0400
Received: from server4.pinguin-hosting.de ([88.198.11.108]:33686 "EHLO
	server4.pinguin-hosting.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551AbYEOP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:57:16 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 11:57:16 EDT
Date: Wed, 14 May 2008 21:52:53 +0200
From: Michelle Konzack <linux4michelle@tamay-dogan.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: Hardware designt to prevent Damages... [WAS: [patch 23/37] i2c-piix4: Blacklist two mainboards]
Message-ID: <20080514195253.GB5673@freenet.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201225.GX31167@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513201225.GX31167@suse.de>
X-Message-Flag: Improper configuration of Outlook is a breeding ground for viruses. Please take care your Client is configured correctly. Greetings Michelle.
X-Disclaimer-DE: Eine weitere Verwendung oder die Veroeffentlichung dieser Mail oder dieser Mailadresse ist nur mit der Einwilligung des Autors gestattet.
Organisation: Tamay Dogan Network
X-Operating-System: Linux tp570.private 2.4.27-2-686
X-Uptime: 21:43:31 up 22 min,  3 users,  load average: 0.22, 0.16, 0.10
X-Homepage1: http://www.tamay-dogan.net/
User-Agent: Mutt/1.5.9i
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu May 15 17:46:55 2008
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 482c5aef225781045919312
X-DSPAM-Factors: 27,
	IRC, 0.40000,
	Errors?, 0.40000,
	my+SuperSparc, 0.40000,
	Also, 0.40000,
	X-Disclaimer-DE*mit, 0.40000,
	made, 0.40000,
	END+OF, 0.40000,
	X-Uptime*21+43, 0.40000,
	Url*li, 0.40000,
	Date*May, 0.40000,
	sensors+detect, 0.40000,
	never, 0.40000,
	25+schrieb, 0.40000,
	nice+Day, 0.40000,
	Oh, 0.40000,
	MSN+LinuxMichi, 0.40000,
	To*suse.de>, 0.40000,
	even+my, 0.40000,
	Cc*redhat.com>, 0.40000,
	Cc*redhat.com>, 0.40000,
	Cc*Domenico, 0.40000,
	from, 0.40000,
	CPU+survived, 0.40000,
	X-Uptime*43+31, 0.40000,
	Electronic, 0.40000,
	Wire, 0.40000,
	letting, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello *,

I in creation of a new Enterprise building small ARM based portable
Computers and I make heavy use of I2C and 1-Wire...

Now I have gooten the following from the LKM:


Am 2008-05-13 13:12:25, schrieb Greg KH:
> We had a report that running sensors-detect on a Sapphire AM2RD790
> motherbord killed the CPU. While the exact cause is still unknown,
> I'd rather play it safe and prevent any access to the SMBus on that
> machine by not letting the i2c-piix4 driver attach to the SMBus host
> device on that machine. Also blacklist a similar board made by DFI.
------------------------ END OF REPLIED MESSAGE ------------------------

Hell, since I do not depend on LOW-BUDGET, I have  never  killed  a  CPU
even by SICK programming even my SuperSparc CPU survived.

Please can anyone advice me, about VERY VERY  good  Hardware  design  to
prevent its destruction by software Errors?

You can even send me examples of such broken Hardware...

Oh yes, since I am using exclusivly Debian GNU/Linux none of my  project
will work with a well known proprietary OS and my hardware specs will be
entirely open even if I code the stuff my own (currently).

Thanks, Greetings and nice Day
    Michelle Konzack
    Systemadministrator
    24V Electronic Engineer
    Tamay Dogan Network
    Debian GNU/Linux Consultant


-- 
Linux-User #280138 with the Linux Counter, http://counter.li.org/
##################### Debian GNU/Linux Consultant #####################
Michelle Konzack   Apt. 917                  ICQ #328449886
+49/177/9351947    50, rue de Soultz         MSN LinuxMichi
+33/6/61925193     67100 Strasbourg/France   IRC #Debian (irc.icq.com)


