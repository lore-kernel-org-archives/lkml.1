Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbXJKA1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbXJKA1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbXJKA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:27:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33235 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXJKA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:26:59 -0400
Date: Wed, 10 Oct 2007 18:25:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Marvell's 88SE6121 SATA driver in Kernel 2.4
In-reply-to: <1192034882.346153.169030@19g2000hsx.googlegroups.com>
To: Mike <mail2mz@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <470D6D62.1020000@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1192034882.346153.169030@19g2000hsx.googlegroups.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> Hello,
> 
> Anyone know if Kernel2.4 support the Marvell's 88SE6121 SATA
> controller? Or any other similar SATA controller follows AHCI? Does
> Kernel2.4 use libata or CAM-ata?
> 
> Thanks for any help,
> 
> Mike
> 

There were some libata backports to 2.4, but I think they are quite out 
of date now and lacking many bug fixes. It would be far better to 
upgrade to 2.6 for SATA support.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

