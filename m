Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYBDMLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYBDMLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBDMLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:11:32 -0500
Received: from ozlabs.org ([203.10.76.45]:45557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYBDMLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:11:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5] typesafe callbacks
Date: Mon, 4 Feb 2008 23:11:18 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042311.18762.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   More typesafety is usually good, and these patches apply that to some 
common callbacks, using a new conditional cast.

(I'm nominally on holiday for all of Feb, so my replies will be sporadic.  
Please sort this out amongst yourselves).

Cheers!
Rusty.
