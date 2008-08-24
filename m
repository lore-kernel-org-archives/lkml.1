Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYHXGOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYHXGOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 02:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYHXGOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 02:14:30 -0400
Received: from cpsmtpo-eml02.kpnxchange.com ([213.75.38.151]:4041 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbYHXGO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 02:14:29 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11356] Linux 2.6.27-rc3 - build failure: undefined reference to `.lockdep_count_forward_deps'
Date: Sun, 24 Aug 2008 08:13:55 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.nrH.saGsIB@albercik>
In-Reply-To: <VSpL6AnBTS.A.nrH.saGsIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808240813.56525.elendil@planet.nl>
X-OriginalArrivalTime: 24 Aug 2008 06:14:26.0844 (UTC) FILETIME=[A93C15C0:01C905B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11356
> Subject	: Linux 2.6.27-rc3 - build failure: undefined reference to
> 		  `.lockdep_count_forward_deps'
> Submitter	: Frans Pop <elendil@planet.nl> 
> Date		: 2008-08-16 19:11 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121891396320127&w=4

Fixed as per: http://marc.info/?l=linux-kernel&m=121898767530602&w=4
Adrian mentioned that he'd closed the bug, but apparently not.
