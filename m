Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXLTNeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXLTNeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXLTNeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbXLTNeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:06 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/16] lguest: introduce vcpu structure
Date: Thu, 20 Dec 2007 11:33:40 -0200
Message-Id: <11981576363806-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch makes room for the vcpu structure in lguest, already used in
this very same way at lguest64. It's the first part of our plan to
have lguest and lguest64 unified too. 

When two dogs hang out, you don't have new puppies right in the other day.
Some time has to be elapsed. They have to grow first. In this same spirit, having these 
patches _do not_ mean smp guests can be launched (yet)
Much more work is to come, but this is the basic infrastructure.

Enjoy


