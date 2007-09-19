Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXISXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXISXCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbXISXBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:01:44 -0400
Received: from free-electrons.com ([88.191.23.47]:40212 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267AbXISXBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:01:43 -0400
Message-ID: <46F1A2C9.4070506@free-electrons.com>
Date: Thu, 20 Sep 2007 00:29:29 +0200
From: Michael Opdenacker <michael@free-electrons.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Valdis.Kletnieks@vt.edu, Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       john cooper <john.cooper@third-harmonic.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <p73fy1av4jc.fsf@bingen.suse.de>            <46F17B54.6070106@am.sony.com> <12631.1190234722@turing-police.cc.vt.edu> <46F194D5.9050800@am.sony.com>
In-Reply-To: <46F194D5.9050800@am.sony.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Valdis.Kletnieks@vt.edu wrote:
>   
>> Is anybody working on testing that the patchkit "does no harm" for bigger
>> boxes (laptops, desktops, servers)? 
>>     
> Not to my knowledge.  Most of the things it provides are
> only activated by config options.  So my sense is that just
> applying the patches should be harmless.  But we'll need some
> runtime testing to see what affect some of these have on
> big iron.
>   
Tim is right, Linux-Tiny features are only activated by configuration
options.

However, that doesn't prevent us from proposing size reduction changes
impacting all kernel users, in cases a configuration option doesn't make
sense. Extensive testing in the -mm tree will then be required.

Cheers,

    Michael.

-- 
Michael Opdenacker
http://free-electrons.com
+33 621 604 642

