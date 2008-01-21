Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYAUR7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYAUR7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYAUR7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:59:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:49494 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYAUR7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=su9wPotu+LZg8mQpLum5+2w6y3jBqvOcgf10E78I5kZGPfnEdNsBLVJkQAkTK5/jBlxq0gMJh/7p1beyijQI2gDOpupOnVaqCSGcp00CN4PaqH9u/GXIdArKd8djSm5FhyFr4UtoRkWG31ImbGUHdWef0WH0DP7/Mhbwr2JnM9c=
Message-ID: <6101e8c40801210959v1e0f6e55w26187dc93a09a202@mail.gmail.com>
Date: Mon, 21 Jan 2008 18:59:03 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>, "David Miller" <davem@davemloft.net>,
       "Greg KH" <gregkh@suse.de>, "Greg KH" <greg@kroah.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>
Subject: Add common orderly_poweroff() to 2.6.22?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

commit in mainline 10a0a8d4e3f6bf2d077f94344441909abe670f5a is go in
the satble 2.6.22

the grund for this question is http://hup.hu/node/49773 .

-- 
Thanks,
Oliver
