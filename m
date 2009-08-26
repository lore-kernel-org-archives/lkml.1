Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbZHZAeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbZHZAeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZHZAeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:34:24 -0400
Received: from static-76-164-182-57.apid.com ([76.164.182.57]:50581 "EHLO
	waltsputer.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755733AbZHZAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:34:23 -0400
Date: Tue, 25 Aug 2009 19:34:19 -0500 (CDT)
From: Walt Holman <walt@holmansrus.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <828279661.71251246859811.JavaMail.root@mail.holmansrus.com>
In-Reply-To: <1884130464.51251246789620.JavaMail.root@mail.holmansrus.com>
Subject: Re: [Bug #14057] Strange network timeouts w/ e100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.0.1]
X-Mailer: Zimbra 6.0.0_RC1_1684.UBUNTU8_64 (ZimbraWebClient - [unknown] (Linux)/6.0.0_RC1_1684.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14057
> Subject		: Strange network timeouts w/ e100
> Submitter	: Walt Holman <walt@holmansrus.com>
> Date		: 2009-08-20 0:21 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=125072831831443&w=4
> Handled-By	: Krzysztof Halasa <khc@pm.waw.pl>

Hi Rafael,

Krzysztof has a patch which has corrected this issue for me.  Thanks,

-Walt

