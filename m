Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYFURFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYFURFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYFURE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:04:58 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53735 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFURE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:04:57 -0400
Message-ID: <485D34A5.4040000@linux.vnet.ibm.com>
Date: Sat, 21 Jun 2008 22:34:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] introduce task cgroup v2
References: <6599ad830806210056n44c7ff37g7cd643f95aef4aa0@mail.gmail.com> <485CC255.9010504@linux.vnet.ibm.com> <20080621180530.E82D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <6599ad830806210848q1a1538bcw79c2f3217dd49303@mail.gmail.com> <2f11576a0806211001w375d440dua42b56edce25bfda@mail.gmail.com>
In-Reply-To: <2f11576a0806211001w375d440dua42b56edce25bfda@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Or, if you strongly want to task_limit subsystem use res_counter,
> I can be working on improve to res_counter performance instead.

I would prefer that as it would help a common cause and avoid
duplication/maintenance overhead.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
