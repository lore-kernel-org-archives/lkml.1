Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZATIQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZATIQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZATIQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:16:13 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:5623 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZATIQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:16:11 -0500
Date: Tue, 20 Jan 2009 09:15:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12483] Reference to inexistent struct dmi_device_id
 breaks the build
Message-ID: <20090120091502.1d5fc96a@hyperion.delvare>
In-Reply-To: <cX2gZ6Cy9nC.A.UWB.ZJRdJB@chimera>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	<cX2gZ6Cy9nC.A.UWB.ZJRdJB@chimera>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 22:45:44 +0100 (CET), Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12483
> Subject		: Reference to inexistent struct dmi_device_id breaks the build
> Submitter	: Jean Delvare <khali@linux-fr.org>
> Date		: 2009-01-19 01:29 (1 days old)
> 

Yes, this regression is still present.

-- 
Jean Delvare
