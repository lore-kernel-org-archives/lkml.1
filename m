Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbYJTPEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbYJTPEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYJTPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:04:34 -0400
Received: from mp1-smtp-5.eutelia.it ([62.94.10.165]:58826 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbYJTPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:04:34 -0400
From: ROASCIO Paolo <roa@libero.it>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: hex code shown at boot
Date: Mon, 20 Oct 2008 17:06:14 +0200
User-Agent: KMail/1.9.9
References: <200810191630.43517.roa@libero.it> <alpine.LRH.1.10.0810192111240.2000@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0810192111240.2000@twin.jikos.cz>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201706.14339.roa@libero.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sunday 19 October 2008 21:11:58 hai scritto:
>
> Do you get the dump also when you do not user framebuffer console? (i.e.
> boot with vga=normal).

Hallo, thanks for your replay.

Tried with vga=normal as you suggested and both the dmesg output and the 
kern.log are clear. Then should it be a vesafb issue or maybe related to my 
graphic card (nvidia 6800GT)?

I will investigate...

Thanks for your hint

ROASCIO Paolo
