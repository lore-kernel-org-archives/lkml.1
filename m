Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYHSWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYHSWfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYHSWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:35:00 -0400
Received: from japan.chezphil.org ([77.240.5.4]:1829 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000AbYHSWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:34:59 -0400
X-Greylist: delayed 2238 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 18:34:58 EDT
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2008 22:57:37 +0100
Subject: Any intelfb support for 945GME chip id 8086:27ae, used in Eee 901 ?
Message-ID: <1219183057845@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

My new ASUS Eee 901 claims to have:

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME 
Express Integrated Graphics Controller (rev 03)
00:02.0 0300: 8086:27ae

As far as I can see there is not yet any support for this chip, though 
the 945GM (no E on the end) with id 8086:27a2 is supported.

Is someone working on this?  I suppose there's a good chance that the 
differences are small or trivial.

Where does development of the intelfb driver happen?  I have found 
David Airlie's intelfb git tree at kernel.org, but it doesn't seem to 
have been updated for a while.


Thanks for any suggestions.

Phil.




