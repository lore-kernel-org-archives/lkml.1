Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZFWJOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZFWJOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZFWJOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:14:43 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:44912 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZFWJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:14:42 -0400
Message-ID: <4A40AAEA.4040100@t-online.de>
Date: Tue, 23 Jun 2009 11:14:02 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090430)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, stable@kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] FLAT: fix uninitialized ptr with shared libs
References: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain> <1245699332-1872-1-git-send-email-vapier@gentoo.org> <alpine.LFD.2.01.0906221338360.3240@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906221338360.3240@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: E4u7AuZDQhfAWaZFMGaJ84LavOm50A8o0T7Lv36WmstleVaiDgu0WeHLyy6b-Wbggn
X-TOI-MSGID: 2b6bf3f1-b80e-4e72-9cbb-78567e7a69cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> IOW, the whole patch really seems to be total and utter crap. Why didn't 
> people spend a bit more effort lookin at it?

Just sloppiness, I'm afraid.

> IOW, shouldn't the patch be something like the appended?
> 
> UNTESTED. I did not compile this, or the previous patch. I have not tried 
> it. I'm not going to commit it. I'm hoping to get a patch back that is 
> tested and/or explains my concerns with the previous one..

Your version seems to work fine.  Please apply it.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
