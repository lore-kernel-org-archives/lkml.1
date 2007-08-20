Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbXHTKpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbXHTKpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXHTKpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:45:23 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:47479 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751303AbXHTKpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:45:22 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] [-mm] FS: file name must be unique in the same dir in procfs
Date: Mon, 20 Aug 2007 12:45:17 +0200
User-Agent: KMail/1.9.7
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <1187605699.2920.147.camel@acpi-hp.sh.intel.com>
In-Reply-To: <1187605699.2920.147.camel@acpi-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201245.17780.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 20 August 2007 schrieb Zhang Rui:
> Files name must be unique in the same directory.
> 
> Bug is reported here: 
> http://bugzilla.kernel.org/show_bug.cgi?id=8798

Then I'd say fix the callers. This will paper over bugs.

	Regards
		Oliver

