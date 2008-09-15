Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYIOEdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYIOEdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 00:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYIOEdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 00:33:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYIOEdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 00:33:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Noonan <steven@uplinklabs.net>
Subject: Re: frustrating ath9k issues in 2.6.27-rc6-00036-ga551b98 (Linus pristine tree)
Date: Mon, 15 Sep 2008 06:38:10 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <f488382f0809121837n69cf4bc5i3dfa04cbf671957b@mail.gmail.com> <200809150239.05729.rjw@sisk.pl> <alpine.LNX.2.00.0809141800360.7280@alcarin.uplinklabs.net>
In-Reply-To: <alpine.LNX.2.00.0809141800360.7280@alcarin.uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150638.10771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 15 of September 2008, Steven Noonan wrote:
> 
> On Mon, 15 Sep 2008, Rafael J. Wysocki wrote:
> 
> > On Saturday, 13 of September 2008, Steven Noonan wrote:
> > > I just had another incident where it disassociated and refused to
> > > reassociate. I got about 100 of these in my dmesg (fixed by unloading
> > > and reloading ath9k):
> > 
> > Is this a regression from 2.6.26?
> > 
> 
> ath9k has been recently introduced (i.e. it's new to 2.6.27). So I'm not 
> certain how to answer. Correct me if I'm wrong but a regression is a new  
> bug for a specific component that did not surface in the previous release, 
> correct?

Yes.

> But if the component didn't exist in the previous version, is it still a
> regression? 

No, it isn't considered as a regression.

Thanks,
Rafael
