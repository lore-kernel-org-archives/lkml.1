Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZBZMfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZBZMfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZBZMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:35:44 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38759 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZBZMfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:35:43 -0500
Date: Thu, 26 Feb 2009 12:35:40 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: =?utf-8?B?0JTQstGD0YDQtdGH0LXQvdGB0LrQuNC5INCf0LDQstC10Ls=?= 
	<paveldvlip@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Boot problem with newest kernel versions
Message-ID: <20090226123540.GA18840@silver.sucs.org>
References: <49A657ED.8020103@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49A657ED.8020103@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 11:50:53AM +0300, Двуреченский Павел wrote:
> I have a boot fail on newest kernel versions. See here: 
> http://forums.fedoraforum.org/showthread.php?t=208828
> After reinstall Fedora 10 I have the same problem.
> 
> When I select in GRUB the newest kernel version 
> (2.6.27.15-170.2.24.fc10.x86_64) and after I see "Loading...", I see this:
> Unable to access resume device (/dev/dm-1)
> mount: error mounting /dev/root on /sysroot as ext3: No such file or 
> directory

Are you sure this isn't an "initrd has been misbuilt" problem (check the
sizes and contents)? You might also have more joy asking on the Fedora
mailing list ( http://www.redhat.com/mailman/listinfo/fedora-list )...

-- 
Sitsofe | http://sucs.org/~sits/
