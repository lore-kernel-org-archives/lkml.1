Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYGHHv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYGHHv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYGHHvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:51:22 -0400
Received: from ozlabs.org ([203.10.76.45]:43160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYGHHvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:51:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] stop_machine enhancements and simplifications
Date: Tue, 8 Jul 2008 17:50:55 +1000
User-Agent: KMail/1.9.9
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Max Krasnyansky <maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081750.55536.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   Here are the three stop_machine patches I've queued for the next merge
window.  The first two are pretty well tested via linux-next, the last is
recent but fairly straightforward.

   I'm assuming that Jason and/or Mathieu have need for the ALL_CPUS mod,
but it can be removed by the last of these patches (left in to reduce
transition breakage).

Feedback welcome as always,
Rusty.
