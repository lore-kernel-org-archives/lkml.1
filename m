Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZGHXdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZGHXdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbZGHXdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:33:09 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:51300 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756740AbZGHXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:33:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=KKXModdnrt+07VqkwmPAh9pU+zuuw1Q3JGhSR8+AHNnaOZWHl9TfRfLaUTltTXHj;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <451B5C45-2F95-4892-8766-7596BD16B7C7@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Suggested code change:  Add /proc/system_type to determine system type / behaviour
Date: Wed, 8 Jul 2009 16:33:03 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec795a80486b90054ee346c1fa0b876dec73350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



	IMO, The Linux Kernel should have a single coarse /proc/system_type  
value to determine whether
	the behaviour of the system should be desktop or server or embedded/ 
desktop or embedded/server.

	Secondary values such as CFS
	/proc/sys/kernel/sched_granularity_ns COULD then have appropriately  
default values set.

	MItchell Erblich

	

	
