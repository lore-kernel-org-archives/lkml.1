Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZBSUGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZBSUGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZBSUGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:06:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZBSUGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:06:33 -0500
Message-ID: <499DBBC4.5090605@zytor.com>
Date: Thu, 19 Feb 2009 12:06:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vt_kern.h program reference
References: <499CF2F1.8050102@oracle.com> <499CF611.8070205@zytor.com> <499D86A3.9030804@oracle.com>
In-Reply-To: <499D86A3.9030804@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> H. Peter Anvin wrote:
>> Randy Dunlap wrote:
>>> Does anyone know the location of this program?
>>>
>>> from include/linux/vt_kern.h:
>>>
>>>  * fixed.  The linux/Documentation directory includes a code snippet
>>>  * to save and restore the text font.
>>>
>> You can save and restore a font via the setfont command from the kbd
>> package.
> 
> Thanks for the reply.
> I suppose that I asked my question poorly, so I'll try again.
> 
> Does the linux/Documentation directory include such a code snippet
> or is the comment above incorrect?
> 

A small grep shows it to be incorrect.

	-hpa

