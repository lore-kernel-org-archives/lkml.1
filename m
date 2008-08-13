Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYHMOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYHMOS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbYHMORj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:17:39 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:4126 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbYHMORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:17:38 -0400
Message-ID: <48A2ECED.5020507@wpkg.org>
Date: Wed, 13 Aug 2008 16:17:17 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> . Making sure all apps use libmalware.so is trivial compared to
>> solving 3).
> 
> the other thing is.. all applications ALREADY use such a library. It's
> called "glibc".

Hmm, are you sure about "all"?
Those compiled statically don't.


-- 
Tomasz Chmielewski
http://wpkg.org

