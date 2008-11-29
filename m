Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbYK2FBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbYK2FBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 00:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbYK2FBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 00:01:45 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:44861 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYK2FBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 00:01:44 -0500
Message-ID: <4930CCA9.9070505@oracle.com>
Date: Fri, 28 Nov 2008 21:01:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-11-26-17-00 uploaded (hwmon / dev_attr_name)
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
In-Reply-To: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4930CCAC.0065:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2008-11-26-17-00 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/


I'm getting lots of these build errors:

drivers/hwmon/built-in.o:(.data+0x7c70): multiple definition of `dev_attr_name'

-- 
~Randy
