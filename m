Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbXKEIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbXKEIHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXKEIH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:07:27 -0500
Received: from 170.Red-213-96-222.staticIP.rima-tde.net ([213.96.222.170]:36093
	"EHLO smtp.ferdyx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXKEIH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:07:26 -0500
Date: Fri, 2 Nov 2007 00:05:07 +0000
From: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Josh Logan <joshtlogan@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       linux-kernel@vger.kernel.org
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071102000507.4fb427a5@snowcone>
In-Reply-To: <20071101215348.GA17449@electric-eye.fr.zoreil.com>
References: <20071029061532.5d10dfc6@snowcone>
	<20071029083333.18a4dab7@the-village.bc.nu>
	<4729FC36.3040000@gmail.com>
	<20071101215348.GA17449@electric-eye.fr.zoreil.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 22:53:48 +0100
Francois Romieu <romieu@fr.zoreil.com> wrote:
> Josh Logan <joshtlogan@gmail.com> :
> [...]
> > I have had this board for a few months as well and I have needed to 
> > patch the driver to use 0x0001 as well.
> 
> Ok.
> 
> Can people give the patch below a try before I submit it to Jeff ?

Yes, that works.

Thanks,
-- 
Ciaran McCreesh
