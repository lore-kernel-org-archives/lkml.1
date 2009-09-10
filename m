Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZIJLus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZIJLus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZIJLur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:50:47 -0400
Received: from poutre.nerim.net ([62.4.16.124]:57603 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZIJLuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:50:46 -0400
Date: Thu, 10 Sep 2009 13:50:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Crane Cai <crane.cai@amd.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: add new AMD SMBus device ID
Message-ID: <20090910135047.2a55ccca@hyperion.delvare>
In-Reply-To: <20090910080427.GA10945@crane-desktop>
References: <20090910080427.GA10945@crane-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Crane,

On Thu, 10 Sep 2009 16:04:27 +0800, Crane Cai wrote:
> Add new SMBus device ID for SB900
> 
> ---
> Hi Jean,
> 
> We follow your point, new patch submitted, please apply.

Applied, thanks. FYI, I also had to list the SB900 in
Documentation/i2c/busses/i2c-piix4 and drivers/i2c/busses/Kconfig. Next
time, please include these changes in your patch. The completed patch
can be seen at:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-piix4-add-amd-SB900-smbus-device-id.patch

Will a datasheet for the SB900 be released to the public at some point
in the future? That would be useful for us developers.

Thanks,
-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
