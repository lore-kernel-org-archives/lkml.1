Return-Path: <linux-kernel-owner+w=401wt.eu-S1765067AbZDCPwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765067AbZDCPwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZDCPwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:52:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13304 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZDCPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:52:30 -0400
Date: Fri, 3 Apr 2009 17:52:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: checkpatch doesn't like CRLF?
Message-ID: <20090403175221.23130af6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

FYI, checkpatch chokes on:
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/staging-rtl8187se-fix-r-n-line-ends.patch

I suspect it doesn't like CRLFs. It's a rather rare case so I can live
with that bug, but maybe you still want to investigate and fix it.

-- 
Jean Delvare
