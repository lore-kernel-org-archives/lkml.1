Return-Path: <linux-kernel-owner+w=401wt.eu-S1946291AbXD3QSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946291AbXD3QSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946034AbXD3QSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:18:40 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423581AbXD3QQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:16:43 -0400
Message-ID: <46361643.509@zytor.com>
Date: Mon, 30 Apr 2007 09:16:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 07/12] i386: Add missing !X86_PAE dependincy to the 2G/2G
 split.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com> <m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> When in PAE mode we require that the user kernel divide to be
> on a 1G boundary.  The 2G/2G split does not have that property
> so require !X86_PAE

?????

	-hpa
