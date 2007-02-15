Return-Path: <linux-kernel-owner+w=401wt.eu-S1161380AbXBOV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161380AbXBOV31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161382AbXBOV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:29:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161380AbXBOV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:29:27 -0500
Message-ID: <45D4D08B.4040903@redhat.com>
Date: Thu, 15 Feb 2007 16:28:43 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, "Bryan O'Sullivan" <bos@serpentine.com>
Subject: Re: linux-kernel mercurial repository tags are gone!
References: <45D4AB24.9050306@redhat.com> <45D4C83E.3030304@goop.org>
In-Reply-To: <45D4C83E.3030304@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Chuck Ebbert wrote:
>> Only "tip" and "v2.6.20-rc7" have tags now:
>>
>> 	http://www2.kernel.org/hg/linux-2.6/tags
>>
>> Apparently convert-repo blew the rest away on Jan 31:
>>
>> 	http://www2.kernel.org/hg/linux-2.6/rev/f99a8b402753
>>   
> 
> It was fixed for a while, and then it broke again.  Bryan said that the
> tip manifest seems to be pointing to the wrong version of .hgtags.

A sneaky way to get the information is to browse the revision
history for Makefile, then follow the appropriate link to get
the commit that changed the kernel version.


