Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYCMAQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYCMAQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbYCMAQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:16:18 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:45130 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbYCMAQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:16:17 -0400
Message-ID: <47D87279.7070905@keyaccess.nl>
Date: Thu, 13 Mar 2008 01:16:57 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Dave Jones <davej@codemonkey.org.uk>, linux-acpi@vger.kernel.org,
       Adam M Belay <abelay@mit.edu>, Zhao Yakui <yakui.zhao@intel.com>,
       Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PNP: increase the maximum number of resources
References: <20080312151452.GA4523@codemonkey.org.uk> <200803121345.21297.lenb@kernel.org>
In-Reply-To: <200803121345.21297.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-08 18:45, Len Brown wrote:

> Thomas worked on a patch to make resource allocation dynamic and do away
> with these limits.  Unfortunately it was rather large and it wasn't in
> time for the 2.6.25-rc1 window.  So right now we are on a trajectory
> for 2.6.25 to behave exactly like 2.6.24.
> Indeed, I don't think that patch made it into the test tree,
> so unless we revive that patch, it will miss 2.6.26 as well.

It rather violently broke ISAPnP.

Rene.
