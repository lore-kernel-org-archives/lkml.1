Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbXEXTWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbXEXTWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXEXTWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:22:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbXEXTWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:22:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Romano Giannetti <romano.giannetti@gmail.com>
Subject: Re: 2.6.21.1 fails to suspend/resume  to disk  (sort of)
Date: Thu, 24 May 2007 21:27:40 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <1179905115.7043.25.camel@localhost> <200705231857.33012.rjw@sisk.pl> <1179984058.12599.1.camel@localhost>
In-Reply-To: <1179984058.12599.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242127.41003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 24 May 2007 07:20, Romano Giannetti wrote:
> On Wed, 2007-05-23 at 18:57 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 23 May 2007 11:57, Romano Giannetti wrote:
> > > On Wed, 2007-05-23 at 11:05 +0200, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > On Wednesday, 23 May 2007 09:25, Romano Giannetti wrote:
> > > > > http://lkml.org/lkml/2007/5/23/38
> > > > 
> > > > Please see http://bugzilla.kernel.org/show_bug.cgi?id=8456
> > > > That seems to resemble the symptoms you describe.
> > > > 
> > > 
> > > No, I don't think. The delay I observe is on resume (suspend is very
> > > fast). Moreover, I have no SATA. It seems that my problem came from
> > > pcmcia.
> > 
> > Hmm, there also is this patch: http://lkml.org/lkml/2007/5/22/434
> > 
> Neither this is related. My report was for a delay of 60 seconds on
> resume, not an infinite delay. And I have no bluetooth here.
> 
> I will try to add some data to the bug and then will open a bugzilla
> report.

OK, please add my address to the bugzilla entry's CC list.

Greetings,
Rafael
