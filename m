Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXBIV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXBIV5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 16:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXBIV5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 16:57:50 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40901 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbXBIV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 16:57:50 -0500
Subject: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 08:57:49 +1100
Message-Id: <1171058269.1484.64.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I don't think this is already done (feel free to correct me if I'm
wrong)..

Can we start to NAK new drivers that don't have proper power management
implemented? There really is no excuse for writing a new driver and not
putting .suspend and .resume methods in anymore, is there?

Regards,

Nigel-getting-sick-of-drivers-without-pm-support Cunningham

