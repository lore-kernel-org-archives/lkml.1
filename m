Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbXA3LMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbXA3LMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbXA3LMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:12:36 -0500
Received: from highlandsun.propagation.net ([66.221.212.168]:4345 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933189AbXA3LMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:12:36 -0500
Message-ID: <45BF2823.2090005@symas.com>
Date: Tue, 30 Jan 2007 03:12:35 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9a2pre) Gecko/20070128 Netscape/7.2 (ax) Firefox/1.5 SeaMonkey/1.5a
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: swap map
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the it-would-be-nice department... While I was twiddling with swappiness 
and benchmarking some code, I thought it would be pretty cool if there was a 
node in /proc/<pid> that would show which pages of a process are resident or 
nonresident. I'm not sure that it would be useful very often, but I was 
thinking one could get a snapshot of that, correlated with traces from a 
malloc profiler, to show what portions of a program's memory usage was in 
active use vs idle.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc
   OpenLDAP Core Team            http://www.openldap.org/project/
