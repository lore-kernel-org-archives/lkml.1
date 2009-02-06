Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZBFPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZBFPsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbZBFPrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:47:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758750AbZBFPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:47:21 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       akataria@vmware.com
Subject: [PATCH 0/2] Show hypervisor information on sysfs
Date: Fri,  6 Feb 2009 10:46:55 -0500
Message-Id: <1233935217-24090-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is quite close to the last one I've sent.

Only this one goes with chris' suggestion of showing it on
/sys/hypervisor.



