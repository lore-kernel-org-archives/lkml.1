Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZFCPi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZFCPi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZFCPhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:37:51 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:47263 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbZFCPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:37:50 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC: Style] Kernel coding style for Extended Attributes.
Date: Wed, 3 Jun 2009 10:37:47 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031037.50803.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group;

I notice two different styles being used:
__attribute__ (( ....
__attribute__(( ....

The gcc documentation does not make a comment on this,
in fact, the extended attribute doc page uses both.  ;)

As a matter of fact, there are macros defined that have
both (not at once) expansions.

Is there a recommended style for the kernel source?

Mike
