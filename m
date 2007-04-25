Return-Path: <linux-kernel-owner+w=401wt.eu-S1161784AbXDYRoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161784AbXDYRoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161786AbXDYRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:44:38 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:39418 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161784AbXDYRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:44:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17967.37755.283517.56557@smtp.charter.net>
Date: Wed, 25 Apr 2007 13:44:27 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: John Stoffel <john@stoffel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: Serial console problem in 2.6.21-rc7-mm1 and earlier
In-Reply-To: <Pine.LNX.4.64.0704250923290.26666@schroedinger.engr.sgi.com>
References: <20070424130601.4ab89d54.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241320540.13005@schroedinger.engr.sgi.com>
	<20070424132740.e4bdf391.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241332090.13005@schroedinger.engr.sgi.com>
	<20070424134325.f71460af.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241351400.13382@schroedinger.engr.sgi.com>
	<20070424141826.952d2d32.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241421140.13904@schroedinger.engr.sgi.com>
	<17967.29851.680497.648681@smtp.charter.net>
	<Pine.LNX.4.64.0704250838360.24504@schroedinger.engr.sgi.com>
	<17967.32856.616216.761311@smtp.charter.net>
	<Pine.LNX.4.64.0704250923290.26666@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph> On Wed, 25 Apr 2007, John Stoffel wrote:
>> Ok, no idea then.  It's working for me in 2.6.21-rc7 as long as I
>> don't have more than one console= entry in my kernel boot args. 

Christoph> 2.6.21-rc7 is working fine here too. mm is the problem.

Ah ok.  My issue must be something else then, but I haven't had the
time to chase it down properly.

John
