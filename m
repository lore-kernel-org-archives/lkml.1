Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZAFDVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZAFDVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZAFDV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:21:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZAFDV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:21:27 -0500
Date: Tue, 6 Jan 2009 03:21:18 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Cheng Renquan =?utf-8?B?KOeoi+S7u+WFqCk=?= <crquan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <ak@suse.de>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [git pull] device-mapper patches for 2.6.29
Message-ID: <20090106032118.GC3512@agk.fab.redhat.com>
Mail-Followup-To: Cheng Renquan =?utf-8?B?KOeoi+S7u+WFqCk=?= <crquan@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Andi Kleen <ak@suse.de>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Takahiro Yasui <tyasui@redhat.com>
References: <20081010125159.GK5098@agk.fab.redhat.com> <20090105191824.GP5098@agk.fab.redhat.com> <alpine.LFD.2.00.0901051843570.3057@localhost.localdomain> <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91b13c310901051915i38e05125tb89b3335922d274e@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 11:15:58AM +0800, Cheng Renquan (程任全) wrote:
> So now maybe we can add a null macro to module_refcount if
> CONFIG_MODULE_UNLOAD undefined?
 
Do we even need the test at all?

Alasdair
-- 
agk@redhat.com
