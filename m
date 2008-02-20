Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbYBTHr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbYBTHr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbYBTHrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:47:40 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54209 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758705AbYBTHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:47:37 -0500
X-Greylist: delayed 3010 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 02:47:37 EST
Date: Wed, 20 Feb 2008 07:57:23 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb@vger.kernel.org>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20080220065723.GY25079@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at> <47279EF7.3040406@redhat.com> <20071030212213.GA13410@gamma.logic.tuwien.ac.at> <20071030152816.f2e8dd7c.zaitcev@redhat.com> <20071031061552.GH11722@gamma.logic.tuwien.ac.at> <20071116132256.GA19251@gamma.logic.tuwien.ac.at> <20080214110501.ec400e10.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214110501.ec400e10.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 14 Feb 2008, Pete Zaitcev wrote:
> that you did, after taking care of detection and initialization.
> Look at his dmesg in comment #44 in this:

Yes, that looks very similar.

> > - changing the penultimage argument in the usb_stor_huawei_e220_init
> >   function from 0x1 to 0 stopped this misbehaviour, but
> > 
> > - with the change from 0x1 to 0 the initialization works automatically.
> 
> I may be able to test this.

I test it regularly, last with 2.6.25-rc1, and it works, always. Maybe
it is not the optimal solution, but who knows.

> As you recall, Huawei people themselves suggested nonzero length,

Umpf, ahhaaaa, very interesting.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
Serious error.
All shortcuts have disappeared.
Screen.
Mind.
Both are blank.
                       --- Windows Error Haiku
