Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbYCZSVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbYCZSVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYCZSVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:21:30 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:51598 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbYCZSV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:21:29 -0400
Date: Wed, 26 Mar 2008 20:21:26 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: linux-kernel@vger.kernel.org
Subject: emails in jeopardy - yet another dead RBL being poisoned
Message-ID: <20080326182126.GQ3700@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite many people still have ORDB.ORG RBLs in their email
configurations.  That service shut down 2006, and last week
the domain was poisoned.

So far about a dozen recipient domains have been bouncing
with referral to ORDB...  That will probably continue.

Watch over your email configs, be especially wary of "free"
blacklists.  They have this nasty tendency of becoming
poisonous..

  /Matti Aarnio -- one of  <postmaster@vger.kernel.org>
