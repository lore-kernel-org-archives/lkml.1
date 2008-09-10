Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYIJSHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYIJSHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYIJSHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:07:36 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:62050 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYIJSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:07:35 -0400
Message-ID: <f488382f0809101107h4ce8b912o1093adb44c157005@mail.gmail.com>
Date: Wed, 10 Sep 2008 11:07:32 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Subject: Semi-repeatable hard lockup on 2.6.27-rc6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a hard lockup problem on boot of 2.6.27-rc6. It's sporadic
though. Sometimes it locks, sometimes not. Each time it -does- lock
up, it gets to 'Waiting for uevents to be processed' and then
immediately locks up.

Any ideas?

- Steven
