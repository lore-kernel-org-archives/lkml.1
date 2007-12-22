Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbXLVLe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbXLVLe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 06:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXLVLeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 06:34:19 -0500
Received: from crazy.xmat.net ([91.121.11.163]:54499 "EHLO
	tchaikovsky.artsenscene.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXLVLeS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 06:34:18 -0500
X-Greylist: delayed 728 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 06:34:18 EST
To: djwong@us.ibm.com
Subject: Re: [PATCH] adt7470: Support per-sensor alarm files
X-IlohaMail-Blah: khali@gcu-squad.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <NWhfFTFG.1198323247.5923820.khali@gcu-squad.org>
In-Reply-To: <20071220185703.GT6870@tree.beaverton.ibm.com>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "lm-sensors" <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Date: Sat, 22 Dec 2007 12:34:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Darrick,

Le 20/12/2007, Darrick J. Wong écrit:

>On Thu, Dec 20, 2007 at 10:58:08AM +0100, Jean Delvare wrote:
>> BTW, did you try your driver with lm-sensors 3.0.0?
>
>Yes I did, and it looked ok to me.  Did you find something wrong?

No, I just wanted to make sure that you had tested it. Now that
libsensors relies on drivers implementing the standard sysfs interface,
it is a convenient way to verify that you implemented it properly.

--
Jean Delvare
