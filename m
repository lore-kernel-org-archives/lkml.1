Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYILGcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYILGcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 02:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYILGcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 02:32:23 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36667 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYILGcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 02:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NFB35cZpAs2Vi6mk4duC/luhVhHbrBqABh+Rzd6T/MQX03iWcumbVT0+D7KBhdVL6G
         Bldo3tQUtN2Zaf2nxNJEErElaiajaAJj4NtikE0qDcZeccQsOQelw5bd/wowCYO7jTzK
         WPeMmUaJfYUyn/Lv1a37w0bdJ9h/jxt+113aU=
Message-ID: <48CA0CED.3000302@gmail.com>
Date: Fri, 12 Sep 2008 08:32:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <htejun@gmail.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <m1mykyh2fu.fsf_-_@frodo.ebiederm.org>	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com>	<m1tzf593ny.fsf@frodo.ebiederm.org>	<486E2C3B.6020603@gmail.com> <20080704161200.GA1440@suse.de>	<m1lk052ptp.fsf@frodo.ebiederm.org> <487D6A24.9070	<m1zlnu60uc.fsf@frodo.ebiederm.org> <48C912CF.7080000@gmail.com> <48C9178A.4040307@bull.net>
In-Reply-To: <48C9178A.4040307@bull.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery napsal(a):
> Jiri Slaby wrote:
>> Any progress here? Nothing seems reached lkml...
> 
> Have a look at Greg's tree. :)
> He started to merge the last patches today.

Cool! I pulled it 10 mins before I sent the email and it wasn't there. 5
mins after it, it was...

Thanks.
