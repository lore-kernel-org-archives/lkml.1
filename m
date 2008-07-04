Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYGDWvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYGDWvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYGDWva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:51:30 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:41139 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYGDWva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:51:30 -0400
Date: Sat, 05 Jul 2008 00:51:27 +0200
Message-Id: <342518340@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block devices in userland
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/VRyGf46+XcgGUrL91q4F4XVgydyiq/0QcwDAYGOfYpwDNB
 wIx9cCQ3bKOxiIIgjyN07GSJNhdRk8dcgb04VVj/6zi+8YwIq8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>is there an API for writing block device drivers in userland ?

i don`t know if there is some in vanilla, but maybe dm-userspace is worth taking a look at ?
see http://wiki.xensource.com/xenwiki/DmUserspace

regards
roland




List:       linux-kernel
Subject:    block devices in userland
From:       Enrico Weigelt <weigelt () metux ! de>
Date:       2008-07-04 22:11:28
Message-ID: 20080704221127.GA25636 () nibiru ! local
[Download message RAW]


Hi folks,


is there an API for writing block device drivers in userland ?


thx
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------

______________________________________________________________
Jeden Monat 1 hochkarätiger maxdome-Blockbuster GRATIS!
Exklusiv für alle WEB.DE Nutzer. http://www.blockbuster.web.de

