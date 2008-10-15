Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYJOA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYJOA4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYJOA41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:56:27 -0400
Received: from gw.goop.org ([64.81.55.164]:36852 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbYJOA41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:56:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 5] xen: fix some things which make ia64 upset
Message-Id: <patchbomb.1224031839@abulafia.goop.org>
Date: Tue, 14 Oct 2008 17:50:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series corrects some x86-specific things in the generic Xen code,
to allow the ia64 Xen work to proceed.

(There's one xen-netfront patch in the middle of the series, which
I've sent to Jeff Garzik for inclusion.)

Thanks,
	J

