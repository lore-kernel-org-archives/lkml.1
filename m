Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYEMRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYEMRNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYEMRNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:13:42 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:43525 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYEMRNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:13:42 -0400
Message-ID: <008e01c8b51c$ae840ae0$6401a8c0@techwriter>
From: "Yigal Sadgat" <YSadgat1@gcte.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <lsorense@csclub.uwaterloo.ca>,
       <sancelot@free.fr>, <liml@rtr.ca>, <w@1wt.eu>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <jwboyer@linux.vnet.ibm.com>, <joern@logfs.org>,
       <linux-os@analogic.com>, <bart.vanassche@gmail.com>, <mangoo@wpkg.org>,
       <helge.hafting@aitel.hist.no>
References: <005b01c8afc4$77f4ec90$6401a8c0@techwriter> <20080506230954.6e034cba@core>
Subject: Re: Compact Flash Question
Date: Tue, 13 May 2008 10:13:35 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, thank you to all that responded.

My original thought was that perhaps we're experiencing "soft errors". We 
shipped several thousands of systems and a very small number of them (3 to 4 
units) are showing this problem. I'm still waiting for these systems to come 
back to us...

Meanwhile I found out that although we (Engineering) specified "SanDisk 
ONLY" (only because they do wear leveling), our purchasing bought from other 
manufacturers as well (Toshiba, Crucial, Kingstone). Crucial is absolutely 
the LEAST reliable CF (system down!) and furthermore, their "lifetime 
warranty" is a joke.

Regards,
Yigal Sadgat


