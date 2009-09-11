Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZIKBOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZIKBOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZIKBOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:14:20 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56001 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZIKBOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:14:19 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432R98dN1b0bMzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KPS8RO-01-398-02
X-M-MSG: 
Date: Fri, 11 Sep 2009 09:15:33 +0800
From: Crane Cai <crane.cai@amd.com>
To: Jean Delvare <khali@linux-fr.org>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: add new AMD SMBus device ID
Message-ID: <20090911011533.GA5055@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>,
	Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090910080427.GA10945@crane-desktop> <20090910135047.2a55ccca@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090910135047.2a55ccca@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Sep 2009 01:14:07.0699 (UTC) FILETIME=[29330230:01CA327D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Thu, Sep 10, 2009 at 01:50:47PM +0200, Jean Delvare wrote:
> Applied, thanks. FYI, I also had to list the SB900 in
> Documentation/i2c/busses/i2c-piix4 and drivers/i2c/busses/Kconfig. Next
> time, please include these changes in your patch. The completed patch
> can be seen at:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-piix4-add-amd-SB900-smbus-device-id.patch
Thanks.
> 
> Will a datasheet for the SB900 be released to the public at some point
> in the future? That would be useful for us developers.
Yes, in future.

-- 
Best Regards,
- Crane

