Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYIQUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYIQUOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYIQUOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:14:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54678 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYIQUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:14:39 -0400
Message-ID: <48D164B9.7020507@redhat.com>
Date: Wed, 17 Sep 2008 16:12:41 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Singaravelan Nallasellan <singaravelann@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: New IOCTLs
References: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
In-Reply-To: <3baf3d760809170955l5dec0495n93fc373a52a120ae@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Singaravelan Nallasellan wrote:
> I need to send device control messages to the driver. I am planning to
> use the IOCTLs. But I came to know that Linux community does not
> accept any new IOCTLs anymore.
> Can somebody provide the reason behind the decision? Are there any
> better approach to implement the device control interface other than
> sysfs interface. I have some issues in using the sysfs interface.
> Thanks in advance.

IOCTLs are discouraged, but not strictly forbidden.  Is there something about 
sysfs that would make it an unsuitable interface, or are you just having trouble 
finding good documentation on using it?

-- Chris
