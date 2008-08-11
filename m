Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYHKPlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYHKPlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYHKPlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:41:15 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:63734 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYHKPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:41:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=mmm8IfhuY5dHBZfY5/ZoGRApFQIeE4op8+42cGlodhaQo+7JbCm4EexxhmwLINhZbQ
         mlWeSY6taqVC7ORdX0yGnFpLDlCyOr2AXUbj6Y4IPGmI2J/IDwDSXMLnjhQ25gRuSsc3
         WKV/kE4Cf01RTIalJnYfp4/qLIkv8XR/dSk68=
Date: Mon, 11 Aug 2008 21:11:01 +0530
From: Rabin Vincent <rabin@rab.in>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: [Bug #11231] gspca_zc3xx oops - 2.6.27-rc1
Message-ID: <20080811154101.GA1667@debian>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.g4B.pDjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.g4B.pDjnIB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11231
> Subject		: gspca_zc3xx oops - 2.6.27-rc1
> Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
> Date		: 2008-08-02 16:22 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121769418920774&w=4
> Handled-By	: Rabin Vincent <rabin@rab.in>
> Patch		: http://marc.info/?l=linux-kernel&m=121774908213124&w=4

This can be closed.  The patch is now in mainline as
fcf5cb2406827fc9d3f3fe260ac883ef72b8bac0 ("V4L/DVB (8605): gspca: Fix of
gspca_zc3xx oops - 2.6.27-rc1").

Rabin
