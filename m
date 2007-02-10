Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXBJTjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXBJTjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXBJTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:39:41 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:51999 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXBJTjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:39:40 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
Subject: Re: Problem of USB - error 71 : how configure kernel to dongle with chipset
Date: Sat, 10 Feb 2007 20:40:24 +0100
User-Agent: KMail/1.8
Cc: Alex Davis <alex14641@yahoo.com>, linux-kernel@vger.kernel.org
References: <292704.97873.qm@web50210.mail.yahoo.com> <45CDF9F1.4060809@wanadoo.fr>
In-Reply-To: <45CDF9F1.4060809@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702102040.24954.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 10. Februar 2007 17:59 schrieb Thibaud Hulin:
> Thanks. In effect, I already post this question in the ndiswrapper list. 
> So, they told me that was a problem of USB and of kernel. Then, I'm 
> looking for configuration of the kernel, because I compiled the 2.6.19, 
> but I no more success. Actually, lsusb recognize, then don't recognize 
> the machine a few seconds after. Ndiswrapper can be installed or not, 
> that change nothing.

If you can replicate this without ndiswrapper having been loaded ever,
this is another matter. Post again to the usb list and provide
/var/log/messages.

	Regards
		Oliver
