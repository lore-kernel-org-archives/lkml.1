Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZA2DWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZA2DWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZA2DWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:22:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58340 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZA2DV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:21:59 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH revised] ieee1394: sbp2: add workarounds for 2nd and 3rd generation iPods
Date: Wed, 28 Jan 2009 22:21:50 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <tkrat.a24a8ff6f4c5711f@s5r6.in-berlin.de> <tkrat.9a5f1819d300396d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.9a5f1819d300396d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901282221.50245.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 18:13:20 Stefan Richter wrote:
> as per https://bugs.launchpad.net/bugs/294391.  These got one sample of
> each iPod generation going.  However there still occurred I/O stalls
> with the 3rd generation iPod which remain undiagnosed at the time of
> this writing.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Same workarounds do the trick on the new stack, should be good to go
here too.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

