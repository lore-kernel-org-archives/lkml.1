Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYAYWE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYAYWE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYAYWEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:04:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53462 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbYAYWEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:04:48 -0500
Message-ID: <479A5CF9.2040409@garzik.org>
Date: Fri, 25 Jan 2008 17:04:41 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Halcrow <mhalcrow@us.ibm.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: Re: [PATCH 076/196] ecryptfs: remove version_str file from sysfs
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-76-git-send-email-gregkh@suse.de> <47999CF2.9070805@garzik.org> <20080125175421.GD4242@suse.de> <20080125191407.GL25594@localhost.austin.ibm.com>
In-Reply-To: <20080125191407.GL25594@localhost.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Halcrow wrote:
> On Fri, Jan 25, 2008 at 09:54:21AM -0800, Greg KH wrote:
>> I could not find any userspace tools or documentation that used it
> 
> The version_str handle is only there as a potential convenience for
> users who need to figure out what their module can and cannot do. I
> mentioned it in an article in LJ last year. It does not need to be
> there for any tools to work right, and I do not think that anyone
> really cares about it at this point, so I have no problem with just
> ripping it out.

Cool, well ignore my objection then...

	Jeff




