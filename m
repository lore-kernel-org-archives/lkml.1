Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZCKRLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZCKRLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZCKRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:10:58 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24380 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZCKRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:10:57 -0400
Message-ID: <49B7F107.7030303@oracle.com>
Date: Wed, 11 Mar 2009 10:12:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 11 (staging/multimedia)
References: <20090311225913.51589223.sfr@canb.auug.org.au>
In-Reply-To: <20090311225913.51589223.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49B7F093.02F8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090310:


drivers/staging/go7007/go7007-v4l2.c:1830: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)


-- 
~Randy
