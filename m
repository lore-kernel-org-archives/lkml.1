Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbYEGS6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbYEGS6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932346AbYEGS63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:58:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765886AbYEGS61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:58:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: libata regression in current -git
Date: Wed, 7 May 2008 20:58:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
References: <480D6A25.2040206@trash.net> <200805070035.59272.rjw@sisk.pl> <4820E5B7.3090503@trash.net>
In-Reply-To: <4820E5B7.3090503@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072058.37109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of May 2008, Patrick McHardy wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday, 22 of April 2008, Patrick McHardy wrote:
> >   
> >> I bisected a boot-failure with sata-sis back to this libata-change:
> >>     
> >
> > Has the problem been fixed in 2.6.26-rc1 or in the current -git?
> >   
> 
> Yes, both 2.6.26-rc1 and current -git work fine.

OK, thanks.
