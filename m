Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbXKVQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbXKVQ2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXKVQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:28:23 -0500
Received: from pmx2.sophos.com ([213.31.172.17]:58623 "EHLO pmx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbXKVQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:28:22 -0500
In-Reply-To: <200711221734.01953.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.24-rc] pdflush stuck in D state
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5 November 30, 2005
Message-ID: <OFFB5CFA23.0234652C-ON8025739B.005A23C3-8025739B.005A7B5B@sophos.com>
From: tvrtko.ursulin@sophos.com
Date: Thu, 22 Nov 2007 16:28:22 +0000
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 22/11/2007 16:28:21,
	Serialize complete at 22/11/2007 16:28:21
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-owner@vger.kernel.org wrote on 22/11/2007 16:34:01:

> On Thursday, 22 of November 2007, Tvrtko A. Ursulin wrote:
> > 
> > Hi all,
> > 
> > So as the subject says - pdflush is stuck i D state which means 
> constant load 
> > average of at least one:
> > 
> > root       151  0.0  0.0      0     0 ?        D    Nov20   0:33 
[pdflush]
> 
> Hm, this is supposed to be fixed.  Please see:
> http://bugzilla.kernel.org/show_bug.cgi?id=9323

Doesn't look like the same bug to me - I have only ever seen pdflush get 
stuck in D, not random processes.

Also, I can confirm that -rc3 I am running contains the patch referenced 
in your bugzilla link above.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

