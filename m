Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZHGLJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZHGLJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbZHGLJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:09:09 -0400
Received: from us.einfochips.com ([74.54.47.34]:51313 "EHLO us.einfochips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbZHGLJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:09:08 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 07:09:08 EDT
Message-ID: <4A7C0A16.4050202@einfochips.com>
Date: Fri, 07 Aug 2009 16:33:50 +0530
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: add product_id for Marvell OpenRD Base,
 Client
References: <1249569566-824-1-git-send-email-dhaval.vasa@einfochips.com> <20090806152135.GA26445@suse.de>
In-Reply-To: <20090806152135.GA26445@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 06, 2009 at 08:09:26PM +0530, Dhaval Vasa wrote:
>> reference:
>> http://www.open-rd.org
>>
>> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
>> ---
>>  drivers/usb/serial/ftdi_sio.h |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> You also need to change ftdi_sio.c in order to add support for this
> device id.  Care to redo the patch?

Yes, I will; thanks for pointing out.  I am again submitting patch.

- Dhaval
-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
