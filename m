Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYDDGbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYDDGbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYDDGbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:31:33 -0400
Received: from nn7.de ([85.214.94.156]:49766 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYDDGbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:31:32 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <pdYe6zNQVl.A.fp.nEW9HB@albercik>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Apr 2008 08:31:29 +0200
Message-Id: <1207290689.4511.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> Subject		: 2.6.25-rc6 regression - hang on resume
> Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> Date		: 2008-03-25 04:44 (10 days old)

Yes. The machine resumes and display stays black using s2ram -f -p
(blindly typing reboot etc on keyboard does what is expected). However
display comes back on 2.6.24.

Soeren
