Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbYBEWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbYBEWyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYBEWyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:54:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYBEWyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:54:07 -0500
Message-ID: <47A8E90D.4000008@redhat.com>
Date: Tue, 05 Feb 2008 17:54:05 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: vapier.adi@gmail.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: New RTC drivers don't provide the sysctl to set max user frequency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is every application that uses /proc/sys/dev/rtc/max-user-freq
supposed to be updated to use the new /sys interface?
