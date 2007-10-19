Return-Path: <linux-kernel-owner+w=401wt.eu-S966603AbXJSOtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966603AbXJSOtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966426AbXJSOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:49:12 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:40031 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966361AbXJSOtL (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:49:11 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
Date: Fri, 19 Oct 2007 16:48:32 +0200
User-Agent: KMail/1.9.7
Cc: carsteno@de.ibm.com, Mike Lampard <mike@secnet.net.au>,
       kvm-devel@lists.sourceforge.net, Aurelien Jarno <aurelien@aurel32.net>,
       Linux-kernel@vger.kernel.org
References: <47189371.7080104@de.ibm.com> <4718B4DB.1000202@de.ibm.com> <Pine.LNX.4.64.0710191618450.1997@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710191618450.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191648.32157.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 19. Oktober 2007 schrieb Jan Engelhardt:
> 
> On Oct 19 2007 15:44, Carsten Otte wrote:
> > Carsten Otte wrote:
> >> First thing we do, is figure whether or not 2.6.23.1 as released breaks our
> >> system too. This way, we can either focus on differences between Linus and
> >> Avi, or turn on the big red warning sign saying "regression".
> >
> > Looks like 2.6.23.1 works fine on that box. We'll leave it running over
> > the weekend with "while true; do make; make clean; done".
> 
> Well, do you happen to use sata_mv?

no, we have nvidia, so its sata_nv.


