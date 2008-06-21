Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYFURXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYFURXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 13:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYFURXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 13:23:04 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:33789 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYFURW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 13:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=g4c2iH5OKANVDHFLVBPJh9x2pQQeuqSGN8inb221OGks/VvXwO6fS7GwgUYXGLyb/S
         oYAu+hAtEkf92kTT6EOzd6X3/KscG9EivAwP52WDWofnJbtqG9AHaAZ/Vrx18wOQX5CI
         JEKDGN5+CYf65zyiy0EH8Yiz16DIoGL/2TK64=
Message-ID: <2f11576a0806211022x3851ad23u635c8812a6821af3@mail.gmail.com>
Date: Sun, 22 Jun 2008 02:22:53 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] introduce task cgroup v2
Cc: "Paul Menage" <menage@google.com>, "Pavel Emelianov" <xemul@openvz.org>,
       containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <485D34A5.4040000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830806210056n44c7ff37g7cd643f95aef4aa0@mail.gmail.com>
	 <485CC255.9010504@linux.vnet.ibm.com>
	 <20080621180530.E82D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <6599ad830806210848q1a1538bcw79c2f3217dd49303@mail.gmail.com>
	 <2f11576a0806211001w375d440dua42b56edce25bfda@mail.gmail.com>
	 <485D34A5.4040000@linux.vnet.ibm.com>
X-Google-Sender-Auth: 819faef0768f69e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Or, if you strongly want to task_limit subsystem use res_counter,
>> I can be working on improve to res_counter performance instead.
>
> I would prefer that as it would help a common cause and avoid
> duplication/maintenance overhead.

okey :)
