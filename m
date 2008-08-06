Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYHFQfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYHFQfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYHFQdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:33:36 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56592 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYHFQdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:33:35 -0400
Message-ID: <4899D221.10001@s5r6.in-berlin.de>
Date: Wed, 06 Aug 2008 18:32:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>       <489872C5.2040508@redhat.com>    <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>    <48995D9F.4010900@s5r6.in-berlin.de> <44714.166.70.238.45.1218029717.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <44714.166.70.238.45.1218029717.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> Haven't gotten any complaints on this code so far actually from
> checkpatch.pl since it does not seem to exist in the 2.6.27 tree. (????)

It should exist in the scripts/ subdirectory.  Check whether execute
permission is set for the file.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=scripts/checkpatch.pl
-- 
Stefan Richter
-=====-==--- =--- --==-
http://arcgraph.de/sr/
