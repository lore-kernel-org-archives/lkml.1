Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZHUIz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZHUIz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 04:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZHUIzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 04:55:25 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:52216 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbZHUIzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 04:55:20 -0400
To: linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] acpi: improvements for Documentation/thermal/sysfs-api.txt
Cc: Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Fri, 21 Aug 2009 10:55:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908211055.20569.elendil@planet.nl>
X-OriginalArrivalTime: 21 Aug 2009 08:55:21.0032 (UTC) FILETIME=[1D1DC480:01CA223D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend adding CC to lkml.)

Here's three patches for your consideration:
1/3: reformat for improved readability
2/3: document passive attribute for thermal zones
3/3: move to acpi directory

The first patch mainly reduces the width of the text to make it fit better 
in normal windows, but also has a number of consistency improvements.

The second patch is the only one that really changes content. It documents 
an attribute that is currently missing in the document.
Note that I've not checked whether the description of the API still 
matches the driver code.

The third patch moves the document to an IMO more logical location and
removes the thermal directory from the top Documentation level.

Cheers,
FJP
