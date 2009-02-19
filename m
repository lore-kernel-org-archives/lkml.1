Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZBSQTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZBSQTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZBSQTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:19:01 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:33836 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZBSQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:19:00 -0500
Message-ID: <499D86A3.9030804@oracle.com>
Date: Thu, 19 Feb 2009 08:19:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vt_kern.h program reference
References: <499CF2F1.8050102@oracle.com> <499CF611.8070205@zytor.com>
In-Reply-To: <499CF611.8070205@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.499D866F.030E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Randy Dunlap wrote:
>> Does anyone know the location of this program?
>>
>> from include/linux/vt_kern.h:
>>
>>  * fixed.  The linux/Documentation directory includes a code snippet
>>  * to save and restore the text font.
>>
> 
> You can save and restore a font via the setfont command from the kbd
> package.

Thanks for the reply.
I suppose that I asked my question poorly, so I'll try again.

Does the linux/Documentation directory include such a code snippet
or is the comment above incorrect?

-- 
~Randy
