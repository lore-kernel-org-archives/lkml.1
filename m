Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYFXQVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYFXQVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYFXQU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:20:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:36535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYFXQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=kzgZDQbVbprzzM2B13++4bNjJIZlkFWgCH7OOj9/5bhuKeAakPS5iwitywwNUS0WoT
         m7y03CtlTuf47WhKZRT+LZMON2Zo2WD8AmfL2XFAhxOMtT/9BppSua4H8wuITJEVWuyO
         ZC3D73raORlWey0+PeiekX1Zc5t1fMxfznVgI=
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 20:16:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/5] x86 nmi_watchdog rework
Message-ID: <48611ec7.1636440a.75ee.2504@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a series of patches over nmi-watchdog code. The base idea
is to simplify the code. Please review. Any feedback is quite welcome!

The patches are over tip/master

commit e3686a37bb64e5ba21d1b522e92d246ba3b28d17
Merge: 9aabe3d... fe4ff08...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Jun 21 08:02:44 2008 +0200

    Merge branch 'out-of-tree'

		- Cyrill -
-- 
