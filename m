Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbYHKWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbYHKWQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYHKWQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:16:01 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:58347 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756045AbYHKWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:15:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bWbZuA/VZP4+AFUsEGMkQsOSQpAVo+yiUS0pWLkKul3jBqZyfjae5eWdcriYgxSIyhyApPhtFgJtFxNFl1qEf1AQS+7o/TZNe8i2+Q9tZo+OWVaViiFSyiVXcNKxRbSd;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11178] Secondary hard drive fails during both hibernation and resume.
Date: Mon, 11 Aug 2008 15:15:49 -0700
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Matthew Wilcox" <willy@linux.intel.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.rpD._EjnIB@albercik>
In-Reply-To: <cX_-nNkxKaF.A.rpD._EjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111515.50622.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 9, 2008 3:43 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11178
> Subject		: Secondary hard drive fails during both hibernation and resume.
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2008-07-30 04:53 (11 days old)
> Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view

Fix pushed to Linus.

-- 
Jesse Barnes, Intel Open Source Technology Center
