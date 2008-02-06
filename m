Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbYBFUzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbYBFUzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYBFUzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:55:09 -0500
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:57009 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbYBFUzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:55:07 -0500
Message-ID: <47AA1E7C.9080205@gentoo.org>
Date: Wed, 06 Feb 2008 20:54:20 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071214)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Maarten Bressers <mbres@gentoo.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] sr: update to follow tray status correctly
References: <20071027225830.585C8657DB@smtp.gentoo.org>	 <1193801523.3321.138.camel@localhost.localdomain>	 <1199551191.3399.29.camel@localhost.localdomain>	 <47A9E9C6.4000802@gentoo.org> <1202324518.3112.104.camel@localhost.localdomain>
In-Reply-To: <1202324518.3112.104.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> However, I think you're right, the vanilla TUR does eat NOT_READY for
> removable media, which CDs are.  Does this fix it?

Works great, thanks!

Daniel
