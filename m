Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYDSJSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYDSJSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYDSJSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:18:15 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:38876 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYDSJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:18:14 -0400
Date: Sat, 19 Apr 2008 11:18:12 +0200
Message-Id: <245581241@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: justinmattock@gmail.com
Subject: Re: latest git freezes my system
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/K82cXy4YnRUCneD61j6l6pj8XJ8a6anXipBWAuA6E9wvMG
 Hhxi6oKypfll+QIWGun+4gWfN2vd9fNnAQ3zozXMjahxfqsynA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

what was the last working kernel/config for you?
if an earlier kernels work without problems, then it`s a regression
can you switch to kernel log console before the freeze and wait for it to happen?
any message/oops/panic there?
does the system respond to sysrq after the freeze ? (http://linuxgazette.net/issue81/vikas.html )

roland


List:       linux-kernel
Subject:    latest git freezes my system
From:       "Justin Mattock" <justinmattock () gmail ! com>
Date:       2008-04-19 7:23:14
Message-ID: dd18b0c30804190023ka240e30u27f20fcbf4295a35 () mail ! gmail ! com
[Download message RAW]

I updated the latest git 2.6.25-02519-g3925e6f on my macbook pro, and
I seem to experiencing a system freeze on a given random number, i.g.
The system will run for five minuetes no problem, then a system
freeze, or during the boot process when the systems try's to load the
modules I'll receive a freeze
or I'll get the system up then within minuetes. Is there something I
need to add to my .config, or is this something more complex.
Also I'm seeing a no module symbols loaded kernel modules not enabled,
in /var/log/kern.log;  could this be related.
any help would be appreciated..

-- 
Justin P. Mattock

__________________________________________________
GRATIS: Movie-FLAT. Jetzt freischalten!
http://freemail.web.de/club/maxdome.htm/?mc=025557

