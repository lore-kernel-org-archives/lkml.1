Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZLRRnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZLRRnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbZLRRnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:43:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbZLRRnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:43:02 -0500
Message-ID: <4B2BBF33.9000902@redhat.com>
Date: Fri, 18 Dec 2009 12:43:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Build error with 2.6.33-rc1
References: <200912181730.42693.tvrtko.ursulin@sophos.com>
In-Reply-To: <200912181730.42693.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> 
> Hi,
> 
> There is first thiw warning about gawk, and then the failure. Not sure if they 
> are related. This build system has mawk installed (Ubuntu 8.10).

Thank you for reporting it.
We are currently trying to fix it for non-POSIX awks as like as mawk.

http://lkml.org/lkml/2009/12/16/458

Fixing patches are already in tip/x86/urgent tree.

Thank you again!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

