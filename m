Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZCFFzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZCFFzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZCFFzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:55:32 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:45610 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZCFFzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:55:31 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid/apple: add module parameter to swap the Command and Option keys
References: <87zlfz8bc1.fsf@burly.wgtn.ondioline.org>
	<49B0B785.4010806@oracle.com>
Date: Fri, 06 Mar 2009 18:55:29 +1300
In-Reply-To: <49B0B785.4010806@oracle.com> (Randy Dunlap's message of "Thu, 05
	Mar 2009 21:41:25 -0800")
Message-ID: <87vdqn8ab2.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> Paul Collins wrote:
>> Apple keyboards have the Command keys (a.k.a. the Apple or "waffle" key)
>> in the positions normally occupied on PC keyboards by the Alt/AltGr keys,
>> and the Option or Alt keys in the position occupied by the so-called
>> Windows keys.  Folks who have been using PC-type computers for too long
>> generally have insurmountable muscle memory in this regard.
>> 
>> This patch adds a module parameter, defaulting to off, that swaps these keys.
>
> Where do you suggest that this option be documented?

Existing practice is to not document hid-apple options

        [burly(linux-2.6)] grep -r fnmode Documentation/ | wc -l
        0

so I'm open to suggestions.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
