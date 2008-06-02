Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYFBQD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYFBQD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYFBQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:03:20 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:47178 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYFBQDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:03:20 -0400
Message-ID: <484419C5.7070207@skyrush.com>
Date: Mon, 02 Jun 2008 10:03:17 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com> <20080602155133.GC933@devserv.devel.redhat.com>
In-Reply-To: <20080602155133.GC933@devserv.devel.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, Jun 02, 2008 at 09:26:48AM -0600, Joe Peterson wrote:
>> P.S.  My stty process sits in "T" - did you say that it would be in "R"
>> if straced and that is correct?
> 
> T would be correct. I'll put together a small diff to printk useful stuff
> when it happens and sent it you tonight/tomorrow

Awesome; that would be great - thanks!

			-Joe
