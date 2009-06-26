Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZFZJNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZFZJNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZFZJNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:13:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55052 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496AbZFZJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:13:39 -0400
Date: Fri, 26 Jun 2009 10:14:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626101446.114edbe2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626072218.GH14078@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
	<20090626072218.GH14078@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Whether a given platform has a 'standard PC' or some custom driver 
> then depends on that driver's init sequence - it's not a central 
> thing.

How exactly do you propose to handle boot memory allocation (eg EBDA)
with a driver ? Perhaps you can explain "driverize" as it isn't in any
dictionary and I'm not at all clear what you are on about ?
