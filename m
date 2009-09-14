Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZINQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZINQNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZINQNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZINQNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:13:49 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dlm patches for 2.6.32
Date: Mon, 14 Sep 2009 11:05:49 -0500
Message-Id: <1252944352-5852-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the dlm patches from -next for the 2.6.32 merge.
Dave


 fs/dlm/lowcomms.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)


Casey Dahlin (1):
      dlm: fix double-release of socket in error exit path

Lars Marowsky-Bree (1):
      dlm: fix connection close handling

Paolo Bonzini (1):
      dlm: use kernel_sendpage

