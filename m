Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZFCIzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZFCIzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZFCIzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:55:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52362 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985AbZFCIzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:55:43 -0400
Date: Wed, 3 Jun 2009 09:55:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Craig Shelley <craig@microtron.org.uk>
Subject: Re: linux-next: manual merge of the usb tree with the ttydev tree
Message-ID: <20090603095547.1641ca7b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090603180734.f175e04f.sfr@canb.auug.org.au>
References: <20090603180734.f175e04f.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a side issue, the last patch has no SOB from Craig in the ttydev tree.

Yes it does...

    Signed-off-by: Craig Shelley <craig@microtron.org.uk>
    
    (Fixed some collisions merging)
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>


> So, I just used the ttydev tree version on the assumption that my
> reasoning above is correct.

and the ttydev tree one is the one to use
