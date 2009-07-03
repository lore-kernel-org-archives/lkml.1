Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZGCGlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZGCGlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZGCGlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:41:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZGCGlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:41:17 -0400
Subject: Re: [PATCH -tip] perf tools: gitignore *.data
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Peter Zijlstra <peterz@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246602740.2322.1.camel@jaswinder.satnam>
References: <1246602740.2322.1.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 12:10:26 +0530
Message-Id: <1246603227.2322.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 12:02 +0530, Jaswinder Singh Rajput wrote:
> perf.data made by perf report is a data file and
> need to be ignored by git
> 

Sorry, due to typo I send new patch.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/


