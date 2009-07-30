Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbZG3QPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbZG3QPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZG3QPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:15:00 -0400
Received: from maila.microsoft.com ([131.107.115.212]:36665 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZG3QO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:14:59 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>, Nicolas Palix <npalix@diku.dk>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Thread-Topic: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Thread-Index: AQHKESz+R90nUjqrxU+OXKKS+83j4ZCOsDkA//+OgpA=
Date: Thu, 30 Jul 2009 16:14:57 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56209A92425@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <200907301737.23849.npalix@diku.dk>
 <20090730155844.GB20557@suse.de>
In-Reply-To: <20090730155844.GB20557@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So far so good it seems, I have been doing some of the integration tests and all seems well.

I have not had time to do any patching myself because I am trying to keep up with the stream
Of patches coming in :)

Hank.


>On thu, Jul 30, 2009 at 09:13:00AM - Greg spoke these immortal words............
>Hank, you are testing the linux-next tree to make sure we haven't broken
>anything yet, right? :)
>
>thanks,
>
>greg k-h

