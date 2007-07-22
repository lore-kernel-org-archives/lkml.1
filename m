Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbXGVQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbXGVQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXGVQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:29:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:39418 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbXGVQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:29:11 -0400
To: stern@rowland.harvard.edu
CC: nigel@suspend2.net, jbms@cmu.edu, miklos@szeredi.hu, rjw@sisk.pl,
       miltonm@bga.com, ying.huang@intel.com, linux-kernel@vger.kernel.org,
       david@lang.hm, linux-pm@lists.linux-foundation.org
In-reply-to: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org>
	(message from Alan Stern on Sun, 22 Jul 2007 11:26:23 -0400 (EDT))
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org>
Message-Id: <E1ICeHX-00025u-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Jul 2007 18:27:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only thing to do is what Rafael has been working on: unfreeze
> things, hope the tasks sort themselves out, and try again.

Have we some proof, that this will untangle the freezing tasks in a
limited time?  Or will it just make the problem harder to trigger?

Miklos
