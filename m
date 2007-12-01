Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbXLAIIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbXLAIIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 03:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXLAIH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 03:07:58 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53035 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXLAIH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 03:07:57 -0500
Date: Sat, 1 Dec 2007 09:07:38 +0100
To: Jaime Velasco Juan <jsagarribay@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb@vger.kernel.org, kristoffer.ericson@gmail.com,
       drussell@redhat.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the Huawei E220
Message-ID: <20071201080738.GA10031@gamma.logic.tuwien.ac.at>
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129150550.86453nubw8i5xi68@webmail.tugraz.at> <20071129185339.GA10445@singular.local> <200711300023.08999.oliver@neukum.org> <20071130163011.GA4223@singular.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130163011.GA4223@singular.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

is this the only addition that should be needed, ortogether with the
changes in option to call the huawei init function?

I tried 2.6.24-rc3 with this patch only and it I again got the infinite
loop of connect/disconnect events instantiating cdroms.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
`Maybe somebody here tipped off the Galactic Police,' said
Trillian. `Everybody saw you come in.'
`You mean they want to arrest me over the phone?' said
Zaphod, `Could be. I'm a pretty dangerous dude when I'm
cornered.'
`Yeah,' said a voice from under the table [Ford's now
completely rat- arsed at this point], `you go to pieces so
fast people get hit by the shrapnel.'
                 --- Zaphod getting paranoid over a phone call.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
