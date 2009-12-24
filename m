Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZLXUwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZLXUwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 15:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZLXUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 15:52:34 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:28113 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZLXUwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 15:52:33 -0500
MIME-Version: 1.0
Message-ID: <727a2e2b-10b7-4088-a83f-879a03516284@default>
Date: Thu, 24 Dec 2009 12:51:15 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       Rik van Riel <riel@redhat.com>, dave.mccracken@oracle.com,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, chris.mason@oracle.com,
       Pavel Machek <pavel@ucw.cz>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: Tmem [PATCH 0/5] (Take 3): Transcendent memory
In-Reply-To: <4B32DF97.5060400@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B33D45C.0196:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What we want is surely tmem but attempt is to better integrate with
> existing infrastructure. Please give me few days as I try to develop
> a prototype.

Sounds good.  I have a few more comments but will switch
to cc'ing just the tmem-devel* list as most people and lists are
probably not interested in this level of detail, but it will be
archived on tmem-devel in case anyone else does want to
follow it.

Thanks,
Dan

* http://oss.oracle.com/pipermail/tmem-devel/
