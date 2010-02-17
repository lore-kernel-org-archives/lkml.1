Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab0BQJvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:51:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067Ab0BQJvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:51:53 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [dlm] Two small sysfs patches
Date: Wed, 17 Feb 2010 09:41:33 +0000
Message-Id: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please queue the following two patches for the next merge window
for dlm. The first one adds a new sysfs variable so that the
lockspace can be obtained without resorting to parsing the
initial line of the sysfs message.

The second one removes some obsolete code relating to one of the
sysfs files,

Steve.


