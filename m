Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXLJOqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXLJOqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXLJOqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:46:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49768 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXLJOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:46:23 -0500
Date: Mon, 10 Dec 2007 06:45:24 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Tarkan Erimer <tarkan@netone.net.tr>
Cc: Jerry Geis <geisj@pagestation.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG in 2.6.23.9
Message-ID: <20071210064524.50d5b709@laptopd505.fenrus.org>
In-Reply-To: <475D0387.1070609@netone.net.tr>
References: <475C46BC.5020101@pagestation.com>
	<20071209134418.14c9f09d@laptopd505.fenrus.org>
	<475D0387.1070609@netone.net.tr>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 11:14:47 +0200
Tarkan Erimer <tarkan@netone.net.tr> wrote:
   
> Hi,
> 
> For a while, I have the same behavior. I tested under 2.6.23.9, 
> 2.6.24-rc3 and rc4. So all of these kernels have the same issue.
> Also, I don't use any proprietary driver. My video card is Intel-945
> and I use the "intel" driver. I use 3D screensavers as well. These
> kernels die after some long idles like 1 or 2 days after. My
> distribution is Kubuntu 7.10 and with Kubuntu kernel this behavior
> did not happened. So, how to track this interesting problem ? Any
> ideas welcomed :-)
> 


well... try to get the oops message out; for many causes of crash that's a good way to find out what happened...
(not always, but it allows us to find patterns if nothing else)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
