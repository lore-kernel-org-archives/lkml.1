Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYIOBHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYIOBHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 21:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYIOBHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 21:07:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:52927 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYIOBHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 21:07:34 -0400
Date: Sun, 14 Sep 2008 18:07:28 -0700 (PDT)
From: Steven Noonan <steven@uplinklabs.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: frustrating ath9k issues in 2.6.27-rc6-00036-ga551b98 (Linus
 pristine tree)
In-Reply-To: <200809150239.05729.rjw@sisk.pl>
Message-ID: <alpine.LNX.2.00.0809141800360.7280@alcarin.uplinklabs.net>
References: <f488382f0809121837n69cf4bc5i3dfa04cbf671957b@mail.gmail.com> <f488382f0809121917vaabfcre710c9e6d4f39a12@mail.gmail.com> <200809150239.05729.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Sep 2008, Rafael J. Wysocki wrote:

> On Saturday, 13 of September 2008, Steven Noonan wrote:
> > I just had another incident where it disassociated and refused to
> > reassociate. I got about 100 of these in my dmesg (fixed by unloading
> > and reloading ath9k):
> 
> Is this a regression from 2.6.26?
> 

ath9k has been recently introduced (i.e. it's new to 2.6.27). So I'm not 
certain how to answer. Correct me if I'm wrong but a regression is a new  
bug for a specific component that did not surface in the previous release, 
correct? But if the component didn't exist in the previous version, is it 
still a regression?

- Steven
