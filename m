Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbZEHUX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbZEHUX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZEHUXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:23:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbZEHUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:23:12 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 0/2] Deal with shadow interrupts after emulated instructions
Date: Fri,  8 May 2009 16:23:05 -0400
Message-Id: <1241814187-5973-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the same patch you're all used to by now, but split in two per
Avi request.


