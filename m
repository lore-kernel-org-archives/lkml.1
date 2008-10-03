Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYJCJ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYJCJ44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYJCJ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:56:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:41182 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJCJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:56:47 -0400
Message-ID: <f488382f0810030256x2859fbf6j3f657621c567287f@mail.gmail.com>
Date: Fri, 3 Oct 2008 02:56:45 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
       lrodriguez@atheros.com, "Ingo Molnar" <mingo@elte.hu>
Subject: ath9k: panic on tip/master
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

Just got a panic on tip. According to the stack trace, ath9k is what
decided to bomb.

http://www.uplinklabs.net/~tycho/linux/ath9k_panic_tip_10.3.2008.jpg

Note: Although it says 'sudo modprobe radeon' on the bash prompt above
the panic, I never got to hit 'enter' on that command before the panic
occurred.

- Steven
