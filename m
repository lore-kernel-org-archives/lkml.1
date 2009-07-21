Return-Path: <linux-kernel-owner+w=401wt.eu-S1751157AbZGUXuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbZGUXuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZGUXuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:50:12 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59337 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZGUXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:50:11 -0400
Date: Tue, 21 Jul 2009 16:49:58 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: linux-acpi@vger.kernel.org, lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: ACPI power meter driver?
Message-ID: <20090721234957.GB20171@plum>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I noticed that section 10.4 of the ACPI 4.0 spec mentions exposing power meter
hardware via the DSDT.  Is anybody currently writing a Linux driver for that
power meter interface?  Or am I volunteering for that task? :)

--D
