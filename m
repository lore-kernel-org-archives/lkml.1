Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab0BLQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:25:28 -0500
Received: from ix.technologeek.org ([213.41.157.215]:54614 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757155Ab0BLQZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:25:26 -0500
From: Julien BLACHE <jb@jblache.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Soeren Sonnenburg <sonne@debian.org>, nicolas@boichat.ch,
       felipe_alfaro@linuxmail.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
References: <1265920725.7103.7.camel@no>
	<878wayk8hn.fsf@sonic.technologeek.org>
	<20100212141457.GA18714@srcf.ucam.org>
Date: Fri, 12 Feb 2010 17:25:22 +0100
In-Reply-To: <20100212141457.GA18714@srcf.ucam.org> (Matthew Garrett's message
	of "Fri, 12 Feb 2010 14:14:57 +0000")
Message-ID: <87zl3eto99.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> wrote:

Hi,

>> If you know how one can determine which GPU is active, let me know. I
>> don't have this information at the moment.
>
> There's a _DSM method in the ACPI tables that you need to execute.

Is it exposed to userspace in any way? Or, better yet, could we have an
MBP backlight driver which would hide all of this from userspace?

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
