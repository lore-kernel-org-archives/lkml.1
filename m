Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323Ab0ALUnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0ALUnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808Ab0ALUnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:43:12 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:36716 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0ALUnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:43:11 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Scott Smedley <ss@aao.gov.au>
Subject: [RFC] Yet another dt3155 driver for drivers/staging
Date: Tue, 12 Jan 2010 22:42:22 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc3; KDE/4.2.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <greg@kroah.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001122242.22774.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would like to propose to your attention a driver for the
dt3155 frame grabber I am using in my experiments since 
the time of 2.6.17 kernel.

It is realized as a character device (not as  a v4l device)
and is currently able to capture video frames in real time
to HDD and display them simultaneously in the application window.

I will really appreciate your comments, suggestions, criticism.

As far as there is another driver already merged in linux-next
for the same hardware is it worth to consider this one for 
merging too?

The driver code could be found here:

http://lfb.issp.bas.bg/~mitov/linux/dt3155pci/

Best regards,

Marin Mitov
