Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZELPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZELPOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZELPNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:13:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58930 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZELPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:13:51 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH 0/2] Deal with shadow interrupts after emulated instructions
Date: Tue, 12 May 2009 11:13:48 -0400
Message-Id: <1242141230-22514-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same as before, addressing avi's comments


