Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZHTSHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZHTSHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZHTSHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 14:07:16 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:45163 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755165AbZHTSHP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 14:07:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=amA0F/563n8Ssx7QH+HSF6+0Iy07/EaiNDtJPhhYssFJWCmwwEjBhYGxB12uCet4r0wrBADUVUWK14US5ewviOq1xs4sVvjYm0qJMHIv7SCyRjXBjkYbNSlHrBHv0QOW;
Date: Thu, 20 Aug 2009 11:07:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciek =?UTF-8?B?SsOzemlld2ljeg==?= " <mjoziew@gmail.com>
Subject: Re: [Bug #13694] i915 phantom TV
Message-ID: <20090820110714.1c7cda8b@jbarnes-g45>
In-Reply-To: <Era7U-todKF.A.pdC.HmIjKB@chimera>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
	<Era7U-todKF.A.pdC.HmIjKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 22:40:46 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13694
> Subject		: i915 phantom TV
> Submitter	: Maciek Józiewicz <mjoziew@gmail.com>
> Date		: 2009-07-02 12:26 (49 days old)

This no longer occurs right?  Maybe it was fixed by

commit cb66c692d1ae257f32dc7f6085cf9cb9f2f6bab8
Author: Ma Ling <ling.ma@intel.com>
Date:   Sun May 31 16:58:32 2009 +0800

If we can identify the fix we can submit it to the 2.6.30.x stable
series.


-- 
Jesse Barnes, Intel Open Source Technology Center
