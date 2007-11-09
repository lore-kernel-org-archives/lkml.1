Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbXKIQsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbXKIQsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXKIQsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:48:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXKIQsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:48:22 -0500
Message-ID: <47348F54.2080507@redhat.com>
Date: Fri, 09 Nov 2007 11:48:20 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.23: GRUB reports "Setup signature not found"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple people have now reported this error message with 2.6.23.
Updating GRUB fixes it:

https://bugzilla.redhat.com/show_bug.cgi?id=370391
https://bugzilla.redhat.com/show_bug.cgi?id=371321
