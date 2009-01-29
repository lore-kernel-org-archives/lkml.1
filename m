Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZA2RJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZA2RJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZA2RJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:09:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51238 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZA2RJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:09:02 -0500
Date: Thu, 29 Jan 2009 12:08:59 -0500
From: Dave Jones <davej@redhat.com>
To: Xiaoning Ding <dingxn@ymail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core
	processors
Message-ID: <20090129170859.GA3162@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Xiaoning Ding <dingxn@ymail.com>, linux-kernel@vger.kernel.org
References: <20090129024539.GA17541@redhat.com> <213679.55387.qm@web59907.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <213679.55387.qm@web59907.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 08:32:41AM -0800, Xiaoning Ding wrote:

 > >  > Thanks for the correction. 
 > >  > My experiments need to reduce CPU speed. However, I
 > > can only reduce the speed by about 30% (from 2.67GHz to
 > > 2GHz) with ACPI. That is not enough for the experiments. 
 > > 
 > > The ACPI P-states are nearly always correct, so you
 > > won't be
 > > able to go below 2GHz on this system.
 > 
 > That's true for changing P-States with ACPI. But I can still get slower speed with clock modulation, right?

Clock modulation will lower the performance, but the clock speed
will remain constant.

	Dave

-- 
http://www.codemonkey.org.uk
