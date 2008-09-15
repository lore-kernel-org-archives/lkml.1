Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYIOAee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYIOAee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 20:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIOAeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 20:34:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYIOAeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 20:34:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: frustrating ath9k issues in 2.6.27-rc6-00036-ga551b98 (Linus pristine tree)
Date: Mon, 15 Sep 2008 02:39:05 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <f488382f0809121837n69cf4bc5i3dfa04cbf671957b@mail.gmail.com> <f488382f0809121917vaabfcre710c9e6d4f39a12@mail.gmail.com>
In-Reply-To: <f488382f0809121917vaabfcre710c9e6d4f39a12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150239.05729.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 of September 2008, Steven Noonan wrote:
> I just had another incident where it disassociated and refused to
> reassociate. I got about 100 of these in my dmesg (fixed by unloading
> and reloading ath9k):

Is this a regression from 2.6.26?

Rafael
